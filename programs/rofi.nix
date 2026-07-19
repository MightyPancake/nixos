{ config, pkgs, lib, froot, ... }:

let
  # Path to the rofi config inside your flake
  rofiConfig = builtins.path {
    path = "${froot}/home/rofi/config.rasi";
  };

  # pywal template: renders to ~/.cache/wal/colors-rofi.rasi, @imported by
  # config.rasi so rofi's palette follows the wallpaper the same way kitty's does.
  rofiWalTemplate = builtins.path {
    path = "${froot}/home/rofi/wal-template.rasi";
  };
in
{
  programs.rofi = {
    enable = true;

    # Symlinks config.rasi into ~/.config/rofi/config.rasi, themed to match kitty
    theme = rofiConfig;

    # Optional: specify a terminal for rofi -run (delete if you don't need this)
    # terminal = "alacritty";
  };

  home.file.".config/wal/templates/colors-rofi.rasi".source = rofiWalTemplate;
}
