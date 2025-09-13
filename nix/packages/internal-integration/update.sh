#!/usr/bin/env bash
set -euo pipefail

(
	cd integration
	go get -u ./...
)

nix-update internal-integration --flake --version=skip
