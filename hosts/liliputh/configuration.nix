{ config, pkgs, inputs, froot, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader (Legacy BIOS - Asus EEE PC 1015PEM predates UEFI)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "liliputh";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;

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

  console.keyMap = "pl2";

  users.users.mightypancake = {
    isNormalUser = true;
    description = "Filip";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.variables = {
    EDITOR = "hx";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs froot; };
    users."mightypancake" = import ./home.nix;
  };

  environment.systemPackages = with pkgs; [
    cmatrix
    gnumake
  ];

  # Skip building docs to save space/CPU on weak hardware
  documentation.enable = false;

  # Compressed RAM swap - only 2GB of physical RAM to work with
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.stateVersion = "26.05";
}
