default:
  just --list

# Run eval tests
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose
