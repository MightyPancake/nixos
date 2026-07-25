{ config, pkgs, inputs, froot, ... }:

let
  volumeUp = pkgs.writeShellScript "volume-up" ''
    amixer set Master 5%+ unmute
    vol=$(amixer get Master | grep -Eo '[0-9]+%' | tail -1 | tr -d %)
    notify-send -t 1500 -h string:x-dunst-stack-tag:volume -h int:value:"$vol" Volume "$vol%"
  '';
  volumeDown = pkgs.writeShellScript "volume-down" ''
    amixer set Master 5%- unmute
    vol=$(amixer get Master | grep -Eo '[0-9]+%' | tail -1 | tr -d %)
    notify-send -t 1500 -h string:x-dunst-stack-tag:volume -h int:value:"$vol" Volume "$vol%"
  '';
in
{
  home.username = "mightypancake";
  home.homeDirectory = "/home/mightypancake";

  home.packages = with pkgs; [
    xdotool
    playerctl
    alsa-utils
    libnotify
  ];

  services.dunst = {
    enable = true;
    settings.global = {
      timeout = 1500;
      width = 250;
      corner_radius = 5;
    };
  };

  # Base xterm look and feel. Xft rendering (Monaspace Neon NF) gives us Nerd
  # Font glyphs so starship prompt symbols display correctly even when SSH'd
  # into remote hosts; see fonts.packages in configuration.nix. DejaVu Sans is
  # listed second as an explicit fallback: Monaspace has zero coverage of the
  # Braille Pattern block (U+2800-28FF, used for pixel-art-style ascii art),
  # and without this xterm falls through to Unifont, which draws a visible
  # marker for every dot position even when "off" instead of leaving it blank.
  xresources.properties = {
    "XTerm*termName" = "xterm-256color";
    "XTerm*faceName" = "MonaspiceNe Nerd Font,DejaVu Sans";
    "XTerm*faceSize" = 12;
    "XTerm*geometry" = "100x30";
    "XTerm*saveLines" = 5000;
    "XTerm*scrollBar" = false;
    "XTerm*background" = "#1a1a1a";
    "XTerm*foreground" = "#e0e0e0";
    "XTerm*cursorColor" = "#e0e0e0";
    "XTerm*loginShell" = true;
    "XTerm*metaSendsEscape" = true;
    "XTerm*selectToClipboard" = true;
    "XTerm*utf8" = 1;
    "XTerm.VT100.translations" = "#override\\nCtrl Shift <Key>c: copy-selection(CLIPBOARD)\\nCtrl Shift <Key>v: insert-selection(CLIPBOARD)\\nShift<Key>Return: string(0x0A)";

    # ANSI 16-color palette (One Dark-inspired) so colored CLI output isn't
    # just xterm's dull default colors.
    "XTerm*color0" = "#1a1a1a";
    "XTerm*color1" = "#e06c75";
    "XTerm*color2" = "#98c379";
    "XTerm*color3" = "#e5c07b";
    "XTerm*color4" = "#61afef";
    "XTerm*color5" = "#c678dd";
    "XTerm*color6" = "#56b6c2";
    "XTerm*color7" = "#e0e0e0";
    "XTerm*color8" = "#5c6370";
    "XTerm*color9" = "#e06c75";
    "XTerm*color10" = "#98c379";
    "XTerm*color11" = "#e5c07b";
    "XTerm*color12" = "#61afef";
    "XTerm*color13" = "#c678dd";
    "XTerm*color14" = "#56b6c2";
    "XTerm*color15" = "#ffffff";
  };

  programs.helix.enable = true;

  programs.rofi.enable = true;

  # home-manager's i3 module ships sensible stock keybindings, but its
  # `default` is dropped entirely (not merged per-key) as soon as any key
  # here is customized - a documented nixpkgs quirk. So this spells out the
  # full stock set explicitly, with Enter -> xterm and Space/d -> rofi's
  # drun launcher instead of the stock i3-sensible-terminal/dmenu, and
  # Shift+Q dropped in favor of plain Q for kill.
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      startup = [
        { command = "feh --randomize --bg-fill ~/nixos/wallpapers"; notification = false; }
      ];
      keybindings = {
        "Mod4+Return" = "exec xterm";
        "Mod4+q" = "kill";
        "Mod4+space" = "exec rofi -show drun";
        "Mod4+d" = "exec rofi -show drun";
        "Mod4+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+c" = "reload";

        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";
        "Mod4+a" = "focus parent";

        "Mod4+Shift+Left" = "move left";
        "Mod4+Shift+Down" = "move down";
        "Mod4+Shift+Up" = "move up";
        "Mod4+Shift+Right" = "move right";

        "Mod4+h" = "split h";
        "Mod4+v" = "split v";
        "Mod4+f" = "fullscreen toggle";
        "Mod4+s" = "layout stacking";
        "Mod4+w" = "layout tabbed";
        "Mod4+e" = "layout toggle split";
        "Mod4+Shift+space" = "floating toggle";
        "Mod4+r" = "exec --no-startup-id feh --randomize --bg-fill ~/nixos/wallpapers";

        "Mod4+minus" = "scratchpad show";
        "Mod4+Shift+minus" = "move scratchpad";

        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+0" = "workspace number 10";

        "Mod4+Shift+1" = "move container to workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8";
        "Mod4+Shift+9" = "move container to workspace number 9";
        "Mod4+Shift+0" = "move container to workspace number 10";

        # LAlt+WASD as arrow keys
        "Mod1+w" = "exec xdotool key Up";
        "Mod1+a" = "exec xdotool key Left";
        "Mod1+s" = "exec xdotool key Down";
        "Mod1+d" = "exec xdotool key Right";

        # LAlt+K play/pause, LAlt+I/M volume up/down
        "Mod1+k" = "exec playerctl play-pause";
        "Mod1+i" = "exec --no-startup-id ${volumeUp}";
        "Mod1+m" = "exec --no-startup-id ${volumeDown}";
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
