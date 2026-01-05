# BUILD the EUMETSAT FCIDECOMP software

This describes the build and install of the **H5ZJPEGLS** HDF5 filter plugin from source code.

  - builds the fcidecomp library H5Zjpegls to be used as HDF5 filter plugin
  - HDF5 filter plugin is built as a shared library (PIC), conforming to HDF5 filter plugin API
  - uses cmake, therefore it is quite generic and should work on most recent Operating Systems

Tested on the following 64-bit operating systems:

  - Ubuntu Linux 22.04
  - AlmaLinux 9.6
  - macOS X (from 15.7.x)
  - Windows 11

Other Linux distributions are expected to work but are not tested and are not supported by EUMETSAT; use them at your own risk.

Platform-specific install guides:
  - Linux: [documentation/INSTALL_LINUX.md](./documentation/INSTALL_LINUX.md)
  - Windows: [documentation/INSTALL_WINDOWS.md](./documentation/INSTALL_WINDOWS.md)
  - macOS: [documentation/INSTALL_MACOS.md](./documentation/INSTALL_MACOS.md)

These guides include the full build, install, and test steps for each platform.

CI is exercised on:
  - Ubuntu (ubuntu-latest)
  - AlmaLinux (almalinux:9 container)
  - Windows (windows-latest)
  - macOS (macos-latest)

For the exact tested versions and build/test outputs, check the GitHub Actions runs:
  - [ci-linux actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-linux.yml) for both Ubuntu and Alma Linux versions.
  - [ci-windows actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-windows.yml).
  - [ci-macos actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-macos.yml).

For more details on the builds, check the workflow definitions in the repo:
  - [ci-linux.yml](.github/workflows/ci-linux.yml)
  - [ci-windows.yml](.github/workflows/ci-windows.yml)
  - [ci-macos.yml](.github/workflows/ci-macos.yml)

## Built Libraries

Most libraries are built and linked statically (e.g., CharLS and `libfcicomp_jpegls.a`) to avoid runtime dependencies. These static libraries are linked into a single shared object: the HDF5 filter plugin (`libH5Zjpegls.so` / `.dylib` / `.dll`), which is built as a shared library by design as required by the HDF5 plugin mechanism.
