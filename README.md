# Hierarchical Deterministic Key Generation For Age
[![built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

age-hier helps you generate Age keys based on a BIP-39 seed.

It features a straightforward and well-specified design,
and two CLI implementations,

This repository contains the specification and test data.
It also exposes Nix derivations for both reference implementations.

## Specification

Read [here](./spec).

## Implementations

- [Go](https://github.com/lourkeur/age-hier-go)
- [Rust](https://github.com/lourkeur/age-hier-rust)

## Installation

Build either `.#age-hier-go` or `.#age-hier-rust` via Nix.
It is also possible to
install via `cargo` or `go`
from the respective repositories.

## Usage

Run `age-hier-derive` and enter a mnemonic and optional passphrase as prompted.
The program will deterministically produce an Age private key and write it to the standard output.

More than one private key can be derived from the same seed.
Use the `-i` option to access keys other than the zeroth one.

Note that
while everything should be relatively straightforward,
neither the design nor either implementation
have been studied by anyone holding a master's degree.

Generating random mnemonic phrases is out-of-scope for this tool.

## Checking

`nix flake check`
will ensure that
both implementations
behave as expected
against the test vector.
