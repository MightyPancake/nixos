{ config, pkgs, lib, froot, ... }:

let
  # Path to the rofi config inside your flake
  rofiConfig = builtins.path {
    path = "${froot}/home/rofi/config.rasi";
  };
in
{
  programs.rofi = {
    enable = true;

    # This makes Home Manager symlink the config.rasi into ~/.config/rofi/config.rasi
    theme = rofiConfig;

    # Optional: specify a terminal for rofi -run (delete if you don't need this)
    # terminal = "alacritty";
  };

  # If you want to expose the config directory directly instead of using `theme =`
  # uncomment this block and REMOVE `theme = rofiConfig;`
  #
  # home.file.".config/rofi/config.rasi".source = rofiConfig;
}
