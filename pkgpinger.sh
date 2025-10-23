set -e
SYSTEM=x86_64-linux

nix build --impure .#devShells.$SYSTEM.default
nix path-info --impure --recursive .#devShells.$SYSTEM.default > store-paths.txt
nix build .#container
