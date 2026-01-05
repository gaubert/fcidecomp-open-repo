# EUMETSAT ``fcidecomp`` software

The ``fcidecomp`` software enables decompression of MTG JPEG-LS netCDF files, it works by acting as a HDF5 filter plugin (H5ZJPEGLS), which allows it to be used directly with standard tools that support HDF5 including:

[![ci-linux](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-linux.yml/badge.svg?branch=main)](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-linux.yml)
[![ci-windows](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-windows.yml/badge.svg?branch=main)](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-windows.yml)
[![ci-macos](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-macos.yml/badge.svg?branch=main)](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-macos.yml)

- hdf5 (e.g. h5dump)
- netCDF-C tools (e.g. nccopy, ncdump) 
- netCDF-Java tools (e.g. panoply)
- python (h5py)

fcidecomp is provided as:

- C/C++ source code to be built and installed as HDF5 filter plugin in various Operating Systems, see [BUILD.md](./BUILD.md). Platform-specific guides:
  - [documentation/INSTALL_LINUX.md](./documentation/INSTALL_LINUX.md)
  - [documentation/INSTALL_WINDOWS.md](./documentation/INSTALL_WINDOWS.md)
  - [documentation/INSTALL_MACOS.md](./documentation/INSTALL_MACOS.md)

In addition:

- by using fcidecomp, the EUMETSAT Data-Tailor provides decompression of MTG JEPG-LS netCDF files. See [public GitLab repository](<https://gitlab.eumetsat.int/open-source>)

## Supported Operating Systems 

fcidecomp build is quite generic and should work in most Operating Systems, following 64-bit platforms have been successfully tested:

- Ubuntu Linux 22.04
- AlmaLinux 9.6
- macOS X (from 15.7.x)
- Windows 11
  
Other Linux distributions are expected to work but are not tested and are not supported by EUMETSAT; use them at your own risk.

## Using the ``fcidecomp`` software

See [USAGE.md](./USAGE.md) file.

## Dependencies

Building fcidecomp from source code requires charls, zlib, and hdf5. See [BUILD.md](./BUILD.md). 

Running fcidecomp HDF5 filter plugin (H5ZJPEGLS) requires hdf5 with zlib.

## Installing and Using fcidecomp in a Python Environment

Python users can enable FCIDECOMP either via `hdf5plugin` or by building the plugin and setting `HDF5_PLUGIN_PATH`. See [documentation/PYTHON_INSTALLATION.md](./documentation/PYTHON_INSTALLATION.md) for setup and examples.

## CI Platforms

CI currently runs on:
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

### Tools versions

Following versions have been tested with fcidecomp hdf5 filter plugin

| Name | Version | SPDX licence id | URL |
|---|---|---|---|
| hdf5 | 1.12.* to 1.14.* | BSD 3-Clause | https://www.h5py.org/ |
| netcdf4 | 1.6.2 | - | https://unidata.github.io/netcdf4-python/ |
| libnetcdf | 4.8.1 | MIT | https://www.unidata.ucar.edu/software/netcdf/ |
| python | 3.9 to 3.12 | see https://docs.python.org/3/license.html | https://www.python.org |
| h5py | 2.* and 3.6.0 | BDS 3-Clause | https://www.python.org |

## Inventory Notes

Licenses and copyright information for software dependencies is documented within the [inventory](./inventory) folder.

Files listed under [`inventory/items/data_proprietary.ABOUT`](./inventory/items/data_proprietary.ABOUT) are licensed under EUMETSAT Proprietary license.
