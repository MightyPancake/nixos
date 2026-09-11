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
