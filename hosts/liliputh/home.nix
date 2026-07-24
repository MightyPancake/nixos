{ config, pkgs, inputs, froot, ... }:

{
  home.username = "mightypancake";
  home.homeDirectory = "/home/mightypancake";

  home.packages = [];

  # Base xterm look and feel. Uses a classic bitmap font (no Xft/fontconfig
  # rendering cost, no font package needed) since this machine's CPU is weak.
  xresources.properties = {
    "XTerm*termName" = "xterm-256color";
    "XTerm*font" = "9x15";
    "XTerm*boldFont" = "9x15bold";
    "XTerm*geometry" = "100x30";
    "XTerm*saveLines" = 5000;
    "XTerm*scrollBar" = false;
    "XTerm*background" = "#1a1a1a";
    "XTerm*foreground" = "#e0e0e0";
    "XTerm*cursorColor" = "#e0e0e0";
    "XTerm*loginShell" = true;
    "XTerm*metaSendsEscape" = true;
    "XTerm*selectToClipboard" = true;
  };

  programs.helix.enable = true;

  programs.rofi.enable = true;

  # Stock i3 config (via home-manager's built-in defaults) with two changes:
  # Super+Q to kill the focused window, Super+Space to open rofi in dmenu mode.
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      keybindings = {
        "Mod4+Shift+q" = null;
        "Mod4+q" = "kill";
        "Mod4+space" = "exec rofi -show dmenu";
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
