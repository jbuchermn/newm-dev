{
  description = "newm and pywm - dev shell";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system}; 
    in
    {
      devShell = let
        my-python = pkgs.python3;
        python-with-my-packages = my-python.withPackages (p: with p; [
          # newm
          pycairo
          psutil
          websockets
          python-pam
          pyfiglet
          fuzzywuzzy

          # pywm
          imageio
          numpy
          pycairo
          evdev
          matplotlib

          # dev
          mypy
        ]);
      in
      with pkgs;
      mkShell {
        nativeBuildInputs = [
          meson_0_60
          ninja
          pkg-config
          wayland-scanner
          glslang
        ];

        buildInputs = [
          libGL
          wayland
          wayland-protocols
          libinput
          libxkbcommon
          pixman
          xorg.xcbutilwm
          xorg.xcbutilrenderutil
          xorg.xcbutilerrors
          xorg.xcbutilimage
          xorg.libX11
          seatd
          xwayland
          vulkan-loader
          mesa

          libpng
          ffmpeg
          libcap

          python-with-my-packages
        ];

        shellHook = ''
          bash setup_env.sh
          source newm/dev/env.sh
          cd env
        '';
      };
    }
    );
  }
