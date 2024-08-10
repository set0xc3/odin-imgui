let
  pkgs = import <nixpkgs> {};

  venvDir = ".venv";
  pythonPackages = pkgs.python311Packages;

  libs = [
    "/run/opengl-driver/lib"
    "/run/opengl-driver-32/lib"

    pkgs.stdenv.cc.cc
    pkgs.xorg.libX11

    pkgs.libGL
  ];
in
  pkgs.mkShell {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath libs}";

    buildInputs = [
      pythonPackages.pip

      pkgs.glfw
      pkgs.clang
      pkgs.SDL2
      pkgs.odin
    ];

    shellHook = ''
      export PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH
      export TMPDIR=$HOME/.cache/pip

      if [ -d "${venvDir}" ]; then
        echo "Skipping venv creation, '${venvDir}' already exists"
      else
        ${pythonPackages.python.interpreter} -m venv "${venvDir}"
      fi

      source "${venvDir}/bin/activate"
    '';
  }
