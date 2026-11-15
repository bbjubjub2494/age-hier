#!/usr/bin/env bash
set -euo pipefail

(
	cd rust
	cargo update
)

nix flake prefetch # workaround https://github.com/Mic92/nix-update/issues/687
nix-update age-hier-rust --flake --version=skip
