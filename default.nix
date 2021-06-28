{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/acd49fab8ece11a89ef8ee49903e1cd7bb50f4b7.tar.gz") {} }:

with pkgs;

mkShell rec {
  venvDir = "./.VENV";
  buildInputs = [
    cairo
    poetry
    python3
    python3.pkgs.venvShellHook
  ];
  postShellHook = ''
    export PS1="\$(__git_ps1) $PS1"
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${cairo}/lib/:$LD_LIBRARY_PATH
    poetry install
    poetry install -E doc
    poetry run pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.0.0/en_core_web_sm-3.0.0.tar.gz
    models=("de_core_news_sm"
            "el_core_news_sm"
            "en_core_web_sm"
            "es_core_news_sm"
            "fr_core_news_sm"
            "it_core_news_sm"
           #"ja_core_news_sm"
            "lt_core_news_sm"
            "nb_core_news_sm"
            "nl_core_news_sm"
            "pl_core_news_sm"
            "pt_core_news_sm"
            "ro_core_news_sm"
            "zh_core_web_sm")
    for m in "''${models[@]}";
      do poetry run spacy download $m
    done
    poetry run pip install notebook==6.1.4
    python -m ipykernel install --user --name $name --display-name "Python 3 (with textnets)"
  '';
}
