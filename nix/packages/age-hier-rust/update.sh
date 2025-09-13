#!/usr/bin/env bash
set -euo pipefail

(
	cd rust
	cargo update
)

nix-update age-hier-rust --flake --version=skip
