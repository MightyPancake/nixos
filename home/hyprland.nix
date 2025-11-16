# { config, pkgs, inputs, ... }:

# {
#   # Enable the Hyprland Wayland compositor at the user level
#   wayland.windowManager.hyprland = {
#     enable = true;

#     # Use the Hyprland flake package
#     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

#     # Enable XWayland support for apps that need X11
#     xwayland.enable = true;

#     # Optional: start hyprland-session.target automatically
#     systemd.enable = true;

#     # Keybindings and decoration settings
#     settings = {
#       # decoration = {
#       #   shadow_offset = "0 5";
#       #   "col.shadow" = "rgba(00000099)";
#       # };

#       # Mod key (SUPER = Windows/Command key)
#       "$mod" = "SUPER";

#       # Mouse bindings
#       bindm = [
#         "$mod, mouse:272, movewindow"      # Move window with left-click
#         "$mod, mouse:273, resizewindow"    # Resize window with right-click
#         "$mod ALT, mouse:272, resizewindow" # Alt + left-click resize

#         "$mod, Return, spawn kitty"
#       ];
#     };

#     # Optional: load Hyprland plugins
#     plugins = [
#       # Example plugin: inputs.some_hypr_plugin.packages.${pkgs.stdenv.hostPlatform.system}.default
#     ];
#   };

#   # Optional: write a full Hyprland conf manually
#   # home.file."~/.config/hypr/hyprland.conf".text = ''
#   #   decoration {
#   #     shadow_offset = 0 5
#   #     col.shadow = rgba(00000099)
#   #   }

#   #   $mod = SUPER

#   #   bindm = $mod, mouse:272, movewindow
#   #   bindm = $mod, mouse:273, resizewindow
#   #   bindm = $mod ALT, mouse:272, resizewindow
#   # '';
# }
