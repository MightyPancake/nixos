# hosts/default/secrets.nix
{ config, lib, ... }:

let
  # Path to your untracked secrets file (outside the Nix store)
  # This file is never committed and can be changed per machine
  secretFile = "/home/mightypancake/secrets/tokens/github.token";
in
{
  options.secrets = {
    githubToken = lib.mkOption {
      type = lib.types.str;
      description = "GitHub personal access token for nix flakes access.";
    };
  };

  config.secrets.githubToken = builtins.readFile secretFile;
}
