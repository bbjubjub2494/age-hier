#!/usr/bin/env bash
set -euo pipefail

(
	cd go
	cargo update
)

nix-update age-hier-rust --flake --version=skip
