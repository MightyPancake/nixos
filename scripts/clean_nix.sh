
sudo nixos-rebuild switch --flake /home/mightypancake/nixos
echo "collecting garbage"
sudo nix-collect-garbage
sudo nix-collect-garbage -d
nix-collect-garbage
nix-collect-garbage -d
echo "store optimising"
nix-store --optimise
echo "results"
du -sh /nix/store
# nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"
