# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
    @just --list

# Update all flake inputs
[group('Main')]
update:
    nix flake update

# Lint nix files
[group('dev')]
lint:
    nix fmt

# Check nix flake
[group('dev')]
check:
    nix flake check
