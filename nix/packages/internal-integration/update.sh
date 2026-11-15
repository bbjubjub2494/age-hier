#!/usr/bin/env bash
set -euo pipefail

(
	cd integration
	go get -u ./...
)

nix flake prefetch # workaround https://github.com/Mic92/nix-update/issues/687
nix-update internal-integration --flake --version=skip
