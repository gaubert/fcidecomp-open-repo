# EUMETSAT ``fcidecomp`` software

The ``fcidecomp`` software enables decompression of MTG JPEG-LS netCDF files, it works by acting as a HDF5 filter plugin (H5ZJPEGLS), which allows it to be used directly with standard tools that support HDF5 including:

- hdf5 (e.g. h5dump)
- netCDF-C tools (e.g. nccopy, ncdump) 
- netCDF-Java tools (e.g. panoply)
- python (h5py)

fcidecomp is provided as:

- C/C++ source code to be built and installed as HDF5 filter plugin in various Operating Systems, see the [BUILD.md](./BUILD.md) documentation file.
- already built conda package, to be used directly as HDF5 filter plugin in a conda environment, see the [CONDA.md](CONDA.md) documentation file.

In addition:

- by using fcidecomp, the EUMETSAT Data-Tailor provides decompression of MTG JEPG-LS netCDF files. See [public GitLab repository](<https://gitlab.eumetsat.int/open-source>)
- the python package hdf5plugin (authored by ESRF) also includes fcidecomp decompression https://pypi.org/project/hdf5plugin/

## Supported Operating Systems 

fcidecomp build is quite generic and should work in most Operating Systems, following 64-bit platforms have been successfully tested:

- RockyLinux 8 
- AlmaLinux 9 
- Linux Ubuntu (18.04; 20.04 22.04) 
- Windows (10; 11)

## Using the ``fcidecomp`` software

See [USAGE.md](./USAGE.md) file.

## Dependencies

Building fcidecomp from source code requires charls, zlib, and hdf5. See [BUILD.md](./BUILD.md). 

Running fcidecomp HDF5 filter plugin (H5ZJPEGLS) requires hdf5 with zlib.

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

Licenses and copyright information for software dependencies is documented within the ``inventory`` folder.

Files listed under `inventory/items/data_proprietary.ABOUT` are licensed under EUMETSAT Proprietary license.

