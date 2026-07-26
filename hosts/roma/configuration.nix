  { config, pkgs, inputs, froot, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # For wasi
  nixpkgs.config.allowUnsupportedSystem = true;

  # No dGPU on this machine (Intel iGPU only, unlike maya) - no nvidia block.
  hardware.graphics = {
    enable = true;
    # enable32Bit = true; # only Steam needed this, see programs.steam below
  };

  # power-profiles-daemon (below) manages clocks dynamically - unlike maya
  # this is a battery-life device, so we don't pin cpuFreqGovernor="performance".

  # Bluetooth stuff
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = false;

    disabledPlugins = [
      "handsfree"
      "headset"
    ];

    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
      Policy = {
        AutoEnable = false;
        ReconnectAttempts = 0;
        ReconnectUUIDs = "";
      };
    };
  };

  # bluetooth manager
  services.blueman.enable = true;

  # Bootloader
  # Assumes MrChromebox full UEFI ROM firmware is flashed (gives a real UEFI,
  # same as any other x86 laptop). If this is still on stock ChromeOS
  # depthcharge firmware, this won't work - see liliputh for a legacy-boot
  # (grub, no EFI) example instead.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.default = 0;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Hostname
  networking.hostName = "roma";

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Small eMMC disk - hardlink duplicate files across store paths to save space
  nix.settings.auto-optimise-store = true;

  # Small eMMC disk - reap old generations automatically instead of filling up
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Networking
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

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

  # Compressed RAM swap - only 4GB of physical RAM to work with
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # User account
  users.users.mightypancake = {
    isNormalUser = true;
    description = "Filip";
    # "video" added vs. maya so brightnessctl works without sudo
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Environment variables
  environment.variables = {
    EDITOR = "hx";
    GCM_CREDENTIAL_STORE = "cache";
    GTK_THEME = "Arc-Dark";
    MAKE_FLAKE_HOST = "roma";
    MAKE_FLAKE_DESKTOP = "hyprland";
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
  # programs.ladybird.enable = true; # heavy second browser engine, disabled to save space on eMMC

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.android_sdk.accept_license = true; # only needed if androidsdk below is uncommented

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
    # lldb
    # clang-tools
    bear

    # dev - languages
    gcc   # C
    tinycc # TCC
    clang # C
    go
    lua
    python312
    gawk
    #typst
    #typstyle
    #typst-live
    # emscripten # heavy toolchain, uncomment if hacking on the wasm backend here

    # dev - tools
    kitty
    gnumake
    wget
    git-credential-manager
    git
    git-lfs
    lazygit
    tmux
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    wasmtime
    # pkgsCross.wasi32.stdenv.cc # heavy cross toolchain, uncomment if needed
    #llvmPackages.lld

    # Frama-C + provers (heavy OCaml toolchain, uncomment if doing formal
    # methods work on this machine)
    # framac
    # alt-ergo
    # cvc5
    # z3
    # why3

    # yap
    tree-sitter
    # nodejs_24
    valgrind

    # files
    # onedrive # uncomment if you need OneDrive sync here
    # kdePackages.dolphin # heavy KDE dep under Hyprland - yazi below covers files

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
    # obs-studio # heavy, uncomment if recording/streaming here
    jq
    fzf
    fd
    yazi
    bc #GNU Basic Calculator
    gnome-settings-daemon
    glib-networking
    # python313Packages.gpustat # nvidia-only, no dGPU here
    # chromium
    # Dark theme on QT apps
    kdePackages.qtstyleplugin-kvantum
    catppuccin-kvantum

    # games
    solitaire-tui
    # mangohud # perf overlay, no gaming here
    # protonup-qt # ties to Steam, commented below

    # components
    networkmanager
    bluetuith
    upower
    networkmanagerapplet
    # easyeffects #For microphone being shitty - heavy gstreamer closure, disabled to save space on eMMC
    brightnessctl

    # comms
    # discord-ptb # heavy Electron app, uncomment if needed
    # signal-desktop

    # media
    # spotify-player
    # youtube-tui
    mpv
    imv
    cava
    # vlc # redundant with mpv
    # loupe # redundant with imv

    # fonts
    nerd-fonts.monaspace

    # Useful in my hyprland set up
    matugen
    awww
    wtype
    wayle
    hyprlock
    xsettingsd
    hyprmon
    pywalfox-native
    pywal # needed by change_wallpaper.sh for color generation

    mesa # not "extra" here - this is THE Intel iGPU driver, not a Steam dep

    # Games
    scummvm

    # Studies/studia
    # anki # heavy Qt closure, disabled to save space on eMMC

    # Stormbound Games (huge closure, uncomment only if doing Unity work here)
    # (pkgs.unityhub.override {
    #   extraPkgs = pkgs: with pkgs; [ cpio icu ];
    # })
    # heroku
    # Unity needs those to install stuff
    zip
    unzip
    which
    gnutar
    # vscode # helix (below, via home.nix) is the primary editor here
    # zed-editor # GPU-accelerated, iffy on this iGPU; uncomment to try
    # Darkmode for QT and GTK
    libsForQt5.qt5ct
    arc-theme
    nwg-look

    # slack # heavy Electron, uncomment if needed
    # docker
    # docker-client
    # lazydocker
    # docker-compose
    # jdk11
    # mongosh
    # mongodb-tools #For mongodump
    # redisinsight
    # (androidenv.composeAndroidPackages {
    #   platformVersions = [ "34" ];
    #   buildToolsVersions = [ "34.0.0" ];
    #   includeNDK = true;
    #   ndkVersions = [ "23.1.7779620" ];
    # }).androidsdk

    # AI
    claude-code
    # opencode
  ];

  # docker stack commented above - matching virtualisation flag
  # virtualisation.docker.enable = true;

  # Flatpak runtimes are ~1GB+ each; skip by default on a small eMMC disk
  # services.flatpak.enable = true;
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

  # Steam/gaming perf tuning - not relevant on this hardware, kept commented
  # (rather than deleted) for parity with maya in case that ever changes.
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  #   localNetworkGameTransfers.openFirewall = true;
  # };
  # programs.gamemode.enable = true;
  # services.irqbalance.enable = true;
  hardware.enableRedistributableFirmware = true;

  programs.git.enable = true;
  programs.git.lfs.enable = true;

  # System state version
  system.stateVersion = "26.05";
}
