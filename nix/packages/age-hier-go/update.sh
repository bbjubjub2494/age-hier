#!/usr/bin/env bash
set -euo pipefail

(
	cd go
	go get -u ./...
)

nix-update age-hier-go --flake --version=skip
