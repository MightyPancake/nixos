  { config, pkgs, inputs, froot, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  # services.home-manager.enable = true;

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

  # For wasi
  nixpkgs.config.allowUnsupportedSystem = true;

  # Nvidia stuff
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Needed on Wayland
    modesetting.enable = true;

    # PRIME offload (AMD iGPU + NVIDIA dGPU)
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";
    };

    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
  powerManagement.cpuFreqGovernor = "performance";

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steams needs this apparently
  };

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
  networking.hostName = "maya";

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # AX210 reliability: disable aggressive Wi-Fi power saving
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';

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

  services.gvfs.enable = true;

  services.upower.enable = true;

  services.power-profiles-daemon.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" ];
    # no DE-specific packages here
  };

  # Environment variables
  environment.variables = {
    EDITOR = "hx";
    GCM_CREDENTIAL_STORE = "cache";
    GTK_THEME = "Arc-Dark";
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # Home Manager setup
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs froot; };
    users = {
      "mightypancake" = import ./home.nix;
    };
  };

  # Common applications
  programs.firefox.enable = true;
  programs.ladybird.enable = true;
  # programs.chromium.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # Replace EOL nodejs_20 with nodejs_24
  nixpkgs.overlays = [
    (final: prev: {
      nodejs_20 = prev.nodejs_24;
      nodejs-slim_20 = prev.nodejs-slim_24 or prev.nodejs_24;
    })
  ];

  # Skip building docs for system packages (python doc build is broken upstream)
  documentation.enable = false;

  # Nix LD - For proprietary stuff
  programs.nix-ld.enable = true;

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    monaspace
  ];


  # System packages
  environment.systemPackages = with pkgs; [
    # dev - editors
    # vim
    # helix
    # hx-lsp
    # libclang # DONT USE THIS
    lldb
    clang-tools
    bear
    # glibc
    # glibc.dev
    
    # dev - languages
    gcc   # C
    tinycc # TCC
    clang # C
    go
    lua
    python312
    gawk
    typst
    typstyle
    typst-live

    # dev - tools
    kitty
    gnumake
    wget
    git-credential-manager
    git
    git-lfs
    wasmtime
    pkgsCross.wasi32.stdenv.cc
    llvmPackages.lld

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
    tty-clock
    tree
    cbonsai
    wlogout
    xcursor-pro
    bibata-cursors
    cowsay
    kittysay
    bottom
    btop
    lolcat # funny cat
    bat
    grimblast # Screensots
    appimage-run
    playerctl
    ffmpeg_7
    obs-studio
    jq
    fzf
    fd
    yazi
    bc #GNU Basic Calculator
    gnome-settings-daemon
    glib-networking
    python313Packages.gpustat
    # chromium
    # Dark theme on QT apps
    kdePackages.qtstyleplugin-kvantum
    catppuccin-kvantum

    # games
    solitaire-tui
    mangohud
    protonup-qt

    # components
    networkmanager
    bluetuith
    upower
    networkmanagerapplet
    easyeffects #For microphone being shitty
    brightnessctl

    # comms
    discord-ptb
    # vesktop #Modded discord basically
    
    signal-desktop

    # media
    spotify-player
    # spotifyd
    youtube-tui
    mpv
    imv
    cava
    vlc
    loupe

    # fonts
    nerd-fonts.monaspace

    # Useful in my hyprland set up
    matugen
    awww
    wtype
    # ashell
    wayle
    hyprlock
    xsettingsd
    hyprmon
    pywalfox-native
    pywal # needed by change_wallpaper.sh for color generation

    mesa

    # Games
    scummvm

    # Studies/studia
    # cassandra
    # (python312.withPackages (ps: [ ps.cassandra-driver ]))
    anki

    # Stormbound Games
    (pkgs.unityhub.override {
      extraPkgs = pkgs: with pkgs; [ cpio icu ];
    })
    heroku
    # Unity needs those to install stuff
    zip
    unzip
    which
    gnutar
    vscode
    zed-editor
    # Darkmode for QT and GTK
    libsForQt5.qt5ct
    arc-theme
    nwg-look

    slack
    docker
    docker-client
    lazydocker
    docker-compose
    jdk11
    mongosh
    mongodb-tools #For mongodump
    redisinsight
    (androidenv.composeAndroidPackages {
      platformVersions = [ "34" ];
      buildToolsVersions = [ "34.0.0" ];
      includeNDK = true;
      ndkVersions = [ "23.1.7779620" ];
    }).androidsdk
    # Nvidia
    mesa-demos
    vulkan-tools
    mangohud
    # fullscreen bs of proton
    gamescope

    asusctl

    # AI
    claude-code
    opencode
  ];

  # asusd
  services.asusd = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  # Enable flatpak and avoid annoying user manager hangs on logout
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" "hyprland" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Automatically detect USB disks
  services.udisks2.enable = true;

  environment.debuginfodServers = [
    "valgrind"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # Game performance (perf, gaming, gamer-zone :D)
  programs.gamemode.enable = true;
  services.irqbalance.enable = true;
  boot.kernelParams = [ "amd_pstate=active" ];
  hardware.enableRedistributableFirmware = true;

  programs.git.enable = true;
  programs.git.lfs.enable = true;

  # System state version
  system.stateVersion = "26.05";
}
