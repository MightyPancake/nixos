# Default variables
host ?= juliette
desktop ?= plasma
flake_path ?= $(CURDIR)

.PHONY: switch build test clean dirty

default: switch

switch:
	nixos-rebuild switch --flake path:$(flake_path)#$(host)-$(desktop)

build:
	nixos-rebuild build --flake path:$(flake_path)#$(host)-$(desktop)

test:
	nixos-rebuild test --flake path:$(flake_path)#$(host)-$(desktop)

dirty:
	nixos-rebuild switch --flake path:$(flake_path)#$(host)-$(desktop) --show-trace

desktop-restart:
	systemctl restart display-manager.service

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
	sudo nix-store --optimise
