#!/usr/bin/env nix-shell
#! nix-shell -p python3.pkgs.setuptools python3.pkgs.pip-tools -i bash

pip-compile
