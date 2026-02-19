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
  networking.hostName = "juliette";

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" ];
    # no DE-specific packages here
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
    python312

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

    # games
    solitaire-tui

    # components
    networkmanager
    bluetuith
    upower

    # comms
    discord
    signal-desktop-bin

    # media
    spotify-player
    # spotifyd
    spotify
    youtube-tui
    mpv
    cava
    vlc

    # fonts
    nerd-fonts.monaspace

    # Useful in my hyprland set up
    wtype
    hyprpaper
    ashell
    # hyprpanel
    hyprlock
    # (inputs.quickshell.packages.${pkgs.system}.default)

    mesa

    # Studies
    # cassandra
    # (python312.withPackages (ps: [ ps.cassandra-driver ]))
    anki

    # Stormbound Games
    unityhub
    flatpak
    # vscodium
    # vscode
    vscode-fhs
    dotnet-sdk
    mono
    slack
    slack-term
    # firebase-tools
    docker
    docker-client

    # Nvidia
    mesa-demos
    vulkan-tools
    mangohud
    # fullscreen bs of proton
    gamescope
  ];

  virtualisation.docker.enable = true;

  services.flatpak.enable = true;
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

  programs.git.enable = true;
  programs.git.lfs.enable = true;

  # System state version
  system.stateVersion = "25.11";
}
