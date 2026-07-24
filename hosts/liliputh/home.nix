{ config, pkgs, inputs, froot, ... }:

{
  home.username = "mightypancake";
  home.homeDirectory = "/home/mightypancake";

  home.packages = [];

  programs.helix.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
