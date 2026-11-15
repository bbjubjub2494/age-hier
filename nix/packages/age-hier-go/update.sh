#!/usr/bin/env bash
set -euo pipefail

(
	cd go
	go get -u ./...
)

nix flake prefetch # workaround https://github.com/Mic92/nix-update/issues/687
nix-update age-hier-go --flake --version=skip
