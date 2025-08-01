# EUMETSAT ``fcidecomp`` software

The ``fcidecomp`` software enables decompression of JPEG-LS netCDF files, it is built as hdf5 plugin and normally used with: 

- netCDF-C tools 
- netCDF-Java tools
- python (via h5py)

fcidecomp is provided as:

- C/C++ source code, to be built as hdf5 plugin in any Operating Systems, see `BUILD` file.
- already built conda package, to be used directly as hdf5 plugin in a conda environment, for installing see `CONDA` file.

also notice that:

- The EUMETSAT Data-Tailor also provides decompression of JEPG-LS netCDF files with fcidecomp. See [public GitLab repository](<https://gitlab.eumetsat.int/open-source>)

- the python package hdf5plugin (authored by ESRF) integrates fcidecomp with other compressions https://pypi.org/project/hdf5plugin/


## Supported platforms and installation

fcidecomp build is quite generic and should work in most platforms, at least following 64-bit platforms have been successfully tested:

- RockyLinux 8 
- AlmaLinux 9 
- Linux Ubuntu (18.04; 20.04 22.04) 
- Windows (10; 11)

## Using the ``fcidecomp`` software

See ``USAGE`` file.


## Dependencies

Building fcidecomp requires charls, zlib, and hdf5. See ``BUILD.md`` 

Running fcidecomp plugin requires hdf5 with zlib.

The following software is normally used with the fcidecomp plugin:

* component name, version, SPDX license id, copyright, home_url, comments

* hdf5, 	1.12.* to 1.14.*, 	BSD 3-Clause, 		- , https://www.h5py.org/, - .
* netcdf4, 	1.6.2, 			-, 			- , https://unidata.github.io/netcdf4-python/, - .

* libnetcdf, 	4.8.1, 			MIT , 			- , https://www.unidata.ucar.edu/software/netcdf/, - .

* python, 	3.9 to 3.12, 		see https://docs.python.org/3/license.html, - , https://www.python.org/, - .
* h5py, 	2.* and 3.6.0, 		BSD 3-Clause, 		- , https://www.h5py.org/, - .

## Inventory Notes

Licenses and copyright information for software dependencies up to version 2.0.0
is documented within the ``inventory`` folder.

Files listed under `inventory/items/data_proprietary.ABOUT` are licensed under EUMETSAT Proprietary license.

