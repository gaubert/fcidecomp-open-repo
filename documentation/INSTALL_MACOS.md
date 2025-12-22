# Install on macOS

This guide covers macOS setup for building and testing fcidecomp.

## Prerequisites

- Xcode Command Line Tools
- Homebrew
- Git + Git LFS

Install tools:

  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Dependencies (Homebrew)

Install build and runtime dependencies:

  brew update
  brew install cmake hdf5 zlib netcdf git-lfs charls
  git lfs install

## Build and install fcidecomp

  cmake -S src/fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCHARLS_ROOT="$(brew --prefix charls)"
  cmake --build build --config Release
  cmake --install build --config Release --prefix "$HOME/.local/fcidecomp"

The plugin is installed to:

  $HOME/.local/fcidecomp/hdf5/lib/plugin

Set environment variables:

  export HDF5_PLUGIN_PATH="$HOME/.local/fcidecomp/hdf5/lib/plugin"

## Test the installation

Ensure the sample file is present (LFS):

  git lfs pull -I src/fcidecomp/fcidecomp-test/data/sample.nc

Run the post-install test:

  export HDF5_PLUGIN_PATH="$HOME/.local/fcidecomp/hdf5/lib/plugin"
  ./src/fcidecomp/fcidecomp-test/postInstallationTest.sh

It succeeds if it prints "*** SUCCESS! ***".
