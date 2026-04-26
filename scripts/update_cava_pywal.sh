#!/usr/bin/env bash

set -euo pipefail

DEFAULT_SEGMENTS=3
MIN_SEGMENTS=2
MAX_SEGMENTS=8

RESTART_CAVA=0
SEGMENTS="$DEFAULT_SEGMENTS"
CAVA_CONFIG=""
PYWAL_COLORS_FILE="${PYWAL_COLORS_FILE:-$HOME/.cache/wal/colors}"

find_default_cava_config() {
    local candidates=(
        "$HOME/.config/cava/config"
        "$HOME/.cava"
        "/etc/xdg/cava/config"
        "/etc/cava/config"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -f "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

usage() {
    echo "Usage: $(basename "$0") [options] [segments] [cava_config_path]"
    echo "  --restart-cava    Restart running cava after writing config"
    echo "  -h, --help        Show this help"
    echo "  segments          Number of gradient colors ($MIN_SEGMENTS-$MAX_SEGMENTS), default: $DEFAULT_SEGMENTS"
    echo "  cava_config_path  Optional path to cava config; if omitted, script searches default CAVA config locations"
}

restart_cava_if_requested() {
    if (( RESTART_CAVA == 0 )); then
        return 0
    fi

    if command -v systemctl >/dev/null 2>&1 && systemctl --user --quiet is-active cava.service; then
        systemctl --user restart cava.service
        echo "Restarted cava via systemd user service (cava.service)."
        return 0
    fi

    if pgrep -x cava >/dev/null 2>&1; then
        local old_pid old_tty
        old_pid="$(pgrep -x cava | head -n 1)"
        old_tty="$(readlink -f "/proc/$old_pid/fd/0" 2>/dev/null || true)"

        pkill -x cava
        sleep 0.1

        if [[ -n "$old_tty" && -w "$old_tty" ]]; then
            nohup bash -lc 'exec cava -p "$1" <"$2" >"$2" 2>"$2"' _ "$CAVA_CONFIG" "$old_tty" >/dev/null 2>&1 &
            echo "Restarted cava in previous terminal: $old_tty"
        else
            nohup cava -p "$CAVA_CONFIG" >/dev/null 2>&1 &
            echo "Restarted cava in background (could not reattach to previous terminal)."
        fi
        return 0
    fi

    echo "No running cava process found. Starting cava in background."
    nohup cava -p "$CAVA_CONFIG" >/dev/null 2>&1 &
}

positionals=()
while (($#)); do
    case "$1" in
        --restart-cava)
            RESTART_CAVA=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            while (($#)); do
                positionals+=("$1")
                shift
            done
            ;;
        -*)
            echo "Error: unknown option $1" >&2
            usage
            exit 1
            ;;
        *)
            positionals+=("$1")
            shift
            ;;
    esac
done

if (( ${#positionals[@]} > 0 )); then
    SEGMENTS="${positionals[0]}"
fi

if (( ${#positionals[@]} > 1 )); then
    CAVA_CONFIG="${positionals[1]}"
fi

if (( ${#positionals[@]} > 2 )); then
    echo "Error: too many positional arguments" >&2
    usage
    exit 1
fi

if ! [[ "$SEGMENTS" =~ ^[0-9]+$ ]]; then
    echo "Error: segments must be a number between $MIN_SEGMENTS and $MAX_SEGMENTS" >&2
    exit 1
fi

if (( SEGMENTS < MIN_SEGMENTS || SEGMENTS > MAX_SEGMENTS )); then
    echo "Error: segments must be between $MIN_SEGMENTS and $MAX_SEGMENTS" >&2
    exit 1
fi

if [[ ! -f "$PYWAL_COLORS_FILE" ]]; then
    echo "Error: pywal colors file not found at $PYWAL_COLORS_FILE" >&2
    echo "Run pywal first (for example: wal -i /path/to/wallpaper)" >&2
    exit 1
fi

if [[ -z "$CAVA_CONFIG" ]]; then
    if ! CAVA_CONFIG="$(find_default_cava_config)"; then
        echo "Error: no default cava config file found." >&2
        echo "Checked: $HOME/.config/cava/config, $HOME/.cava, /etc/xdg/cava/config, /etc/cava/config" >&2
        echo "Provide a path explicitly: $(basename "$0") [segments] /path/to/cava/config" >&2
        exit 1
    fi
fi

if [[ ! -f "$CAVA_CONFIG" ]]; then
    echo "Error: cava config not found at $CAVA_CONFIG" >&2
    exit 1
fi

mapfile -t palette < <(grep -E '^#[0-9a-fA-F]{6}$' "$PYWAL_COLORS_FILE")

if (( ${#palette[@]} < 2 )); then
    echo "Error: not enough colors found in $PYWAL_COLORS_FILE" >&2
    exit 1
fi

gradient_colors=()
palette_last_index=$(( ${#palette[@]} - 1 ))

for (( i=0; i<SEGMENTS; i++ )); do
    if (( SEGMENTS == 1 )); then
        index=0
    else
        index=$(( (i * palette_last_index + (SEGMENTS - 1) / 2) / (SEGMENTS - 1) ))
    fi
    gradient_colors+=("${palette[$index]}")
done

colors_csv="$(IFS=,; echo "${gradient_colors[*]}")"

tmp_file="$(mktemp)"

awk -v segments="$SEGMENTS" -v colors_csv="$colors_csv" '
BEGIN {
    split(colors_csv, colors, ",")
    in_color = 0
    inserted = 0
}

function print_gradient_block(   j) {
    print "gradient = 1"
    print "gradient_count = " segments
    for (j = 1; j <= segments; j++) {
        print "gradient_color_" j " = '\''" colors[j] "'\''"
    }
}

/^\[color\]/ {
    in_color = 1
    inserted = 0
    print
    next
}

in_color && /^\[/ {
    if (!inserted) {
        print_gradient_block()
        inserted = 1
    }
    in_color = 0
    print
    next
}

in_color && /^gradient([[:space:]]*|_count[[:space:]]*|_color_[0-9]+[[:space:]]*)=/ {
    if (!inserted) {
        print_gradient_block()
        inserted = 1
    }
    next
}

{ print }

END {
    if (in_color && !inserted) {
        print_gradient_block()
    }
}
' "$CAVA_CONFIG" > "$tmp_file"

mv "$tmp_file" "$CAVA_CONFIG"

echo "Updated $CAVA_CONFIG with $SEGMENTS pywal gradient segment(s):"
for (( i=0; i<SEGMENTS; i++ )); do
    printf '  %d: %s\n' "$((i + 1))" "${gradient_colors[$i]}"
done

restart_cava_if_requested