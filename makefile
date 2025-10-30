CFG ?= "default"

.PHONY = switch test clean

default: switch

switch: 
	nixos-rebuild switch --flake ./#$(CFG)

test:
	echo "Not yet implemented, sorry!"

clean:
	echo "Not yet implemented, sorry!"
