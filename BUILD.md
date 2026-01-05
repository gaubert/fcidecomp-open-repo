# BUILD the EUMETSAT FCIDECOMP software

This describes the build and install of the **H5ZJPEGLS** HDF5 filter plugin from source code.

  - builds the fcidecomp library H5Zjpegls to be used as HDF5 filter plugin
  - HDF5 filter plugin is built as a shared library (PIC), conforming to HDF5 filter plugin API
  - uses cmake, therefore it is quite generic and should work on most recent Operating Systems

it has been tested in following 64-bit Operating Systems:

  - RockLinux 8
  - AlmaLinux 9.6
  - Ubuntu Linux (20.04; 22.04)
  - Opensuse Leap 15.04
  - Windows-10/11 

Platform-specific install guides:
  - [documentation/INSTALL_LINUX.md](./documentation/INSTALL_LINUX.md)
  - [documentation/INSTALL_WINDOWS.md](./documentation/INSTALL_WINDOWS.md)
  - [documentation/INSTALL_MACOS.md](./documentation/INSTALL_MACOS.md)

CI is exercised on:
  - Ubuntu (ubuntu-latest)
  - AlmaLinux (almalinux:9 container)
  - Windows (windows-latest)
  - macOS (macos-latest)

For the exact tested versions or to look at builds outputs and testing, check the GitHub Actions runs:
  - [ci-linux actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-linux.yml) for both Ubuntu and Alma Linux versions.
  - [ci-windows actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-windows.yml).
  - [ci-macos actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-macos.yml).

For more details on the builds, check the workflow definitions in the repo:
  - [ci-linux.yml](.github/workflows/ci-linux.yml)
  - [ci-windows.yml](.github/workflows/ci-windows.yml)
  - [ci-macos.yml](.github/workflows/ci-macos.yml)

