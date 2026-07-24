{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "pl";
    xkb.variant = "";
    windowManager.i3.enable = true;
  };

  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # i3's extraPackages default already pulls in dmenu, i3status and i3lock;
  # xterm is added since nothing else provides a terminal for i3-sensible-terminal.
  environment.systemPackages = [ pkgs.xterm ];
}
