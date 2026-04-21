{ config, pkgs, inputs, froot, ... }:

{
  imports = [
    # Configured programs go here
    ../../programs/rofi.nix
    # kitty should go here but im lazy
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mightypancake";
  home.homeDirectory = "/home/mightypancake";

    # TODO: This doesn't seem to work.
  home.sessionVariables = {
    # EDITOR = "hx";
    # GCM_CREDENTIAL_STORE = "cache";
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.


  home.packages = with pkgs; [
    fastfetch
  ];

  # Fastfetch
  home.file.".config/fastfetch/config".text = ''
    [options]
    colors=true
    image_source=ascii
    ascii_distro=nixos

    [blocks]
    info=true
    cpu=true
    gpu=true
    memory=true
    disk=true
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
  #
  # 

  # Make sure home is included in .bashrc
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      ~/nixos/scripts/splash.sh
    '';

  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.sessionPath = [
    "$HOME/yap"
    "$HOME/nixos/scripts"
  ];

 
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
    '';
    settings ={
      wayland_disable = true;
      # blur
      background = "#111111";
      background_opacity = 0.7;
      background_blur = 9;

      confirm_os_window_close = 0;
      
      # font
      font_size = 15.0;
      font_family = "monaspace neon nf";
    };
  };
  
  programs.starship = {
    enable = true;
  };

  programs.helix = {
    enable = true;

    # Deploy a custom config file
    extraConfig = ''
      theme = "mytheme"

    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
