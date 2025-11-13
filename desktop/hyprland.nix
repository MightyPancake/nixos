{ config, pkgs, inputs, froot, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/hyprland";
        # command = "${pkgs.hyprland}/bin/hyprland -c /home/freerat/config_flake/modules/hyprland/hyprland.conf";
        user = "mightypancake";
      };
    };
  };

  services = {
    xserver = {
      xkb.layout = "pl";
      xkb.variant = "";
      enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Import the upstream Hyprland NixOS module
  imports = [ inputs.hyprland.nixosModules.default ];

  # Enable the system-level Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;   # needed for apps that require X11
    # You can optionally set `package` and `portalPackage` if you want flake versions
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  # Add kitty to system packages
  environment.systemPackages = with pkgs; [
    kitty
  ];

  # Import home for config
  home-manager.users."mightypancake" = import "${froot}/home/hyprland.nix";
}
