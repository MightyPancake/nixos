host ?= "default"

.PHONY = switch test clean

default: switch

switch: 
	nixos-rebuild switch --flake ./#$(host)

test:
	echo "Not yet implemented, sorry!"

gh:
	
	git config --global credential.helper manager
	echo -e "Starting the auth"
	git-credential-manager github login
	echo -e "List of github logins:"
	git-credential-manager github list

# Shamelessly copied from https://github.com/Free-Rat/config_flake
clean:
	# sudo nixos-rebuild switch --flake /home/freerat/config_flake
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

