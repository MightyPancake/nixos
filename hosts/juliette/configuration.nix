{ config, pkgs, inputs, froot, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Bluetooth stuff
  hardware.bluetooth = {
    enable = true;
    # powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  # };

  # bluetooth manager
  services.blueman.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

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
    helix

    # dev - languages
    gcc # C
    go
    lua

    # dev - tools
    kitty
    gnumake
    wget
    git-credential-manager
    git
    framac

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
    spotifyd
    youtube-tui
    mpv
    cava

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
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # System state version
  system.stateVersion = "25.05";
}
