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
  #
  # Built with --enable-direct-color: nixpkgs's stock xterm only goes up to
  # 256-color (SGR 38;5;N), so 24-bit truecolor ANSI art (SGR 38;2;r;g;b)
  # renders wrong. This forfeits the cache.nixos.org binary cache for xterm -
  # it compiles from source wherever this configuration gets built.
  environment.systemPackages = [
    (pkgs.xterm.overrideAttrs (old: {
      configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-direct-color" ];
    }))
  ];
}
