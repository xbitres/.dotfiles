#!/bin/bash
NIX_VERSION=nix-2.3.3

curl -o install-$NIX_VERSION https://releases.nixos.org/nix/$NIX_VERSION/install
sh ./install-$NIX_VERSION
rm install-$NIX_VERSION
