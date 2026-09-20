{ config, pkgs, inputs, froot, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # nix.settings = {
  #   substituters = [
  #     "https://cache.nixos.org"
  #     "https://hyprland.cachix.org"
  #   ];
  #   trusted-substituters = [
  #     "https://cache.nixos.org"
  #     "https://hyprland.cachix.org"
  #   ];
  #   trusted-public-keys = [
  #     "cache.nixos.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #   ];
  # };


  # Bluetooth stuff
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = false;

    disabledPlugins = [
      "handsfree"
      "headset"
    ];

    # powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        # Enable = "Sink,Media,Socket";
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        # FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        # AutoEnable = false;
        AutoEnable = false;
        ReconnectAttempts = 0;
        ReconnectUUIDs = "";
      };
    };
  };

  # bluetooth manager
  services.blueman.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.default = 0;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Hostname
  networking.hostName = "giorgio";

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.fail2ban.enable = true;

  # Time zone and locales
  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Console keymap
  console.keyMap = "pl2";

  services.upower.enable = true;
  # Printing
  services.printing.enable = true;

  # Sound (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    audio.enable = true;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  # hardware.enableAllFirmware = true;

  # User account
  users.users.mightypancake = {
    isNormalUser = true;
    description = "Filip";
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "containerd" ];
    # no DE-specific packages here
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCB9pp8mc7rJnyTYoWDFL9elW6tF9jIZ3x+3ffPW2pL" # maya
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1uwt372zMP7MQLFGP1s5tY9GyAz/cR4NK1V/3eBN7w" # phone / Termius
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJn70KfMISa4UcJW1jlamKzsZhSQ9S5pUkcxgCRP4pAt" # liliputh
    ];
  };

  # Environment variables
  environment.variables = {
    EDITOR = "hx";
    GCM_CREDENTIAL_STORE = "cache";
    # PATH = "/home/yap/:${config.environment.variables.PATH}";
  };

  # Home Manager setup
  home-manager = {
    extraSpecialArgs = { inherit inputs froot; };
    users = {
      "mightypancake" = import ./home.nix;
    };
  };

  # Common applications
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];


# System packages
  environment.systemPackages = with pkgs; [
    # dev - editors
    vim
    # helix
    # helix-gpt
    # hx-lsp
    # libclang # DONT USE THIS
    lldb
    clang-tools
    bear
    # glibc
    # glibc.dev
    
    # dev - languages
    gcc   # C
    clang # C
    go
    lua
    python313

    # dev - tools
    kitty
    gnumake
    wget
    git-credential-manager
    git
    git-lfs

    # Frama-C + provers
    framac
    alt-ergo
    cvc5
    z3
    why3

    # yap
    tree-sitter
    nodejs_24
    valgrind

    # files
    onedrive
    kdePackages.dolphin

    # misc
    tree
    cbonsai
    woomer
    wlogout
    xcursor-pro
    bibata-cursors
    fastfetch
    cowsay
    kittysay
    bottom
    btop
    lolcat # funny cat
    grimblast # Screensots
    appimage-run
    playerctl
    ffmpeg_7
    obs-studio
    jq

    # games
    solitaire-tui

    # components
    networkmanager
    bluetuith
    upower

    # comms
    discord

    # media
    spotify-player
    # spotifyd
    spotify
    youtube-tui
    mpv
    imv
    cava
    vlc

    # fonts
    nerd-fonts.monaspace

    # Useful in my hyprland set up
    wtype
    hyprpaper
    # ashell
    wayle
    hyprlock
    # (inputs.quickshell.packages.${pkgs.system}.default)
    xsettingsd
    hyprmon

    # AI
    claude-code

    # Drives Kata Containers (see the kata block below); ctr comes from
    # containerd and is the low-level fallback if nerdctl misbehaves.
    nerdctl
    containerd
  ];
  virtualisation.docker.enable = true;

  # Kata Containers on cloud-hypervisor: a container runtime that boots each
  # container inside its own microVM. web-yap-runner (yap.nullptr.free) compiles
  # and executes untrusted user-submitted programs, so it runs them under this
  # instead of only a namespace sandbox — an escape then lands in a throwaway
  # guest kernel rather than on this host.
  #
  # nixpkgs' kata-runtime already bakes valid store paths for the guest kernel
  # and rootfs (kata-images) and for virtiofsd into configuration-clh.toml, but
  # its hypervisor paths point at a cloud-hypervisor binary that package does
  # not actually ship, so those get substituted for the real one here.
  environment.etc."kata-containers/configuration.toml".source =
    pkgs.runCommand "kata-configuration-clh.toml" { } ''
      substitute \
        ${pkgs.kata-runtime}/share/defaults/kata-containers/configuration-clh.toml \
        "$out" \
        --replace-fail \
          "${pkgs.kata-runtime}/bin/cloud-hypervisor" \
          "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor"
    '';

  # Kata is driven through containerd, not Docker. Docker's generated OCI spec
  # is rejected by the kata-agent inside the guest ("invalid namespace type"),
  # and no combination of --cgroupns/--ipc/--pid/--network avoids it; containerd
  # is Kata's actually-supported path. The microVM itself boots fine either way.
  virtualisation.containerd = {
    enable = true;
    settings = {
      # Hand the control socket to a group so the yap-runner user service can
      # start containers without being root. The gid is pinned because
      # containerd wants a number here, so it cannot be read back from a
      # dynamically allocated group.
      grpc.gid = 942;
    };
  };
  users.groups.containerd.gid = 942;

  # containerd resolves the shim binary (containerd-shim-kata-v2) off its own
  # PATH, which does not include systemPackages by default.
  systemd.services.containerd.path = [ pkgs.kata-runtime ];

  # web-yap-runner runs inside a long-lived Kata microVM. Untrusted yap programs
  # are then isolated twice: bwrap inside the guest (per request), and the VM
  # boundary itself (from this host). The container image is almost empty on
  # purpose — everything real comes from the read-only /nix bind, exactly like
  # the bwrap-only deployment did, so yap does not need to be packaged for Nix.
  systemd.services.yap-runner-vm =
    let
      runnerDir = "/home/mightypancake/web-yap-runner";
      yapHome = "/home/mightypancake/yap";
      # Compiled yap binaries dlopen their modules by absolute path baked in at
      # compile time, so YAP_HOME must sit at the *same* path inside the guest.
      guestPath = pkgs.lib.makeBinPath [
        pkgs.nodejs_24
        pkgs.bubblewrap
        pkgs.gcc
        pkgs.binutils
        pkgs.coreutils
        pkgs.bash
        pkgs.findutils
        pkgs.gnumake
      ];
      start = pkgs.writeShellScript "yap-runner-vm-start" ''
        set -eu
        nerdctl rm -f yap-runner-vm 2>/dev/null || true
        nerdctl pull --quiet docker.io/library/alpine:latest
        exec nerdctl run --rm --name yap-runner-vm \
          --runtime io.containerd.kata.v2 \
          --cni-path ${pkgs.cni-plugins}/bin \
          -p 127.0.0.1:25116:25116 \
          -v /nix:/nix:ro \
          -v ${yapHome}:${yapHome}:ro \
          -v ${runnerDir}:${runnerDir}:ro \
          -w ${runnerDir} \
          -e PATH=${guestPath}:/usr/bin:/bin \
          -e YAP_HOME=${yapHome} \
          -e YAP_BIN=${runnerDir}/yap_compiler \
          -e YAP_SANDBOX_PROC=bind \
          -e PORT=25116 \
          -e HOST=0.0.0.0 \
          docker.io/library/alpine:latest \
          ${pkgs.nodejs_24}/bin/node src/server.js
      '';
      # The runner needs no outbound network whatsoever: the toolchain comes
      # from the read-only /nix bind, node deps are vendored in the checkout,
      # and untrusted yap code already runs under bwrap --unshare-all. So we
      # sever the guest's internet: drop everything it tries to *initiate* on
      # the nerdctl bridge. Replies to the inbound published 127.0.0.1:25116
      # connection are ctstate ESTABLISHED and keep flowing, so the Cloudflare
      # Tunnel is unaffected — unlike --network none, which would also kill the
      # published port. Fail-closed: if the bridge never appears we let
      # ExecStartPost fail so systemd tears the container back down rather than
      # leave it running with egress open.
      netBlock = pkgs.writeShellScript "yap-runner-vm-netblock" ''
        set -eu
        ipt=${pkgs.iptables}/bin/iptables
        # nerdctl sets up CNI networking asynchronously after `nerdctl run`
        # forks, so nerdctl0 may not exist yet the instant ExecStartPost fires.
        for _ in $(seq 1 60); do
          [ -d /sys/class/net/nerdctl0 ] && break
          sleep 0.5
        done
        $ipt -w -C FORWARD -i nerdctl0 -m conntrack --ctstate NEW -j DROP 2>/dev/null \
          || $ipt -w -I FORWARD -i nerdctl0 -m conntrack --ctstate NEW -j DROP
      '';
      netUnblock = pkgs.writeShellScript "yap-runner-vm-netunblock" ''
        ${pkgs.iptables}/bin/iptables -w -D FORWARD -i nerdctl0 -m conntrack --ctstate NEW -j DROP 2>/dev/null || true
      '';
    in
    {
      description = "web-yap-runner inside a Kata microVM (yap.nullptr.free)";
      after = [ "containerd.service" "network-online.target" ];
      wants = [ "network-online.target" ];
      requires = [ "containerd.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.nerdctl pkgs.kata-runtime pkgs.cni-plugins pkgs.iptables ];
      serviceConfig = {
        ExecStart = start;
        ExecStartPost = netBlock;
        ExecStop = "${pkgs.nerdctl}/bin/nerdctl rm -f yap-runner-vm";
        ExecStopPost = netUnblock;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

  services.flatpak.enable = true;
  # Automatically detect USB disks
  services.udisks2.enable = true;

  environment.debuginfodServers = [
    "valgrind"
  ];

  programs.git.enable = true;
  programs.git.lfs.enable = true;

  # System state version
  system.stateVersion = "25.11";
}
