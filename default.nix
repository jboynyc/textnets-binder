{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/7db146538e49ad4bee4b5c4fea073c38586df7e2.tar.gz") {} }:

with pkgs;

stdenv.mkDerivation rec {
  name = "textnets-notebook-env";
  env = buildEnv { name = name; paths = buildInputs; };
  venvDir = "./TN_ENV";
  buildInputs = [
    python38Full
    python38Packages.venvShellHook
    python38Packages.pycairo
    python38Packages.matplotlib
  ];
  postShellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [stdenv.cc.cc]}
    pip install git+https://github.com/jboynyc/textnets.git@trunk#egg=textnets-stable
    models=("de_core_news_sm"
            "el_core_news_sm"
            "en_core_web_sm"
            "es_core_news_sm"
            "fr_core_news_sm"
            "it_core_news_sm"
            "ja_core_news_sm"
            "lt_core_news_sm"
            "nb_core_news_sm"
            "nl_core_news_sm"
            "pl_core_news_sm"
            "pt_core_news_sm"
            "ro_core_news_sm"
            "zh_core_web_sm")
    for m in "''${models[@]}";
      do python -m spacy download $m
    done
    pip install notebook
    python -m ipykernel install --user --name $name --display-name "Python 3.8 (with textnets)"
  '';
}
