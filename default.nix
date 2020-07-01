{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/7db146538e49ad4bee4b5c4fea073c38586df7e2.tar.gz") {} }:

with pkgs;

  stdenv.mkDerivation rec {
    name = "textnets-notebook-env";
    env = buildEnv { name = name; paths = buildInputs; };
    venvDir = "./TN_ENV";
    buildInputs = [
      python38Packages.venvShellHook
      python38Packages.notebook
      (python38.withPackages(ps: with ps;
        [ click pandas pycairo spacy srsly thinc ujson
          python-igraph toolz ]))
    ];
    shellHook = ''
      export SOURCE_DATE_EPOCH=315532800
    '';
    postShellHook = ''
      export LD_LIBRARY_PATH=${lib.makeLibraryPath [stdenv.cc.cc]}
      pip install git+https://github.com/jboynyc/textnets.git@trunk#egg=textnets-stable
      python -m spacy download en_core_web_sm
      python -m ipykernel install --user --name $name --display-name "Python 3.8 (with textnets)"
    '';
  }
