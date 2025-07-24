# EUMETSAT ``fcidecomp`` software

The ``fcidecomp`` software enables decompression of JPEG-LS netCDF files. it is provided as hdf5 plugin to be used with: 

- netCDF-C tools 
- netCDF-Java tools
- python (via h5py)

fcidecomp is provided as:

- source code, to be built and used in various Operating Systems. (see `BUILD` file)
- already built conda package, to be used directly in a conda environment. (see `CONDA` file)

The EUMETSAT Data-Tailor also provides a customisation with fcidecomp for the decompression of JPEG-LS Meteosat Third Generation (MTG) products. See [public GitLab repository](<https://gitlab.eumetsat.int/open-source>)

(Also, note that the python package hdf5plugin integrates fcidecomp software https://pypi.org/project/hdf5plugin/)


## Supported platforms and installation

``fcidecomp`` software is C/C++ source code which can be built into a shared library to be used as a hdf5 plugin. 

It has been built and tested in following 64-bit platforms:

- RockyLinux 8 
- AlmaLinux 9 
- Linux Ubuntu (18.04; 20.04 22.04) 
- Windows (10; 11)

For building the hdf5 plugin from source code see BUILD.md file.

For installing the already built conda package see CONDA.md file.


## Using the ``fcidecomp`` software

See ``USAGE`` file.

Inventory Notices
-----------------

Licenses and copyright information for software dependencies up to version 2.0.0
is documented within the ``inventory`` folder.

Files listed under `inventory/items/data_proprietary.ABOUT` are licensed under EUMETSAT Proprietary license.

#### Dependencies
For building the plugin see ``BUILD.md`` 

The following is normally used with the fcidecomp software:
* component name, version, SPDX license id, copyright, home_url, comments

* hdf5, 1.12.* to 1.14.*, BSD 3-Clause, - , https://www.h5py.org/, - .
* netcdf4, 1.6.2, -, - , https://unidata.github.io/netcdf4-python/, - .

* libnetcdf, 4.8.1, MIT , - , https://www.unidata.ucar.edu/software/netcdf/, - .

* python, 3.9 to 3.12, see https://docs.python.org/3/license.html, - , https://www.python.org/, - .
* h5py, 2.* and 3.6.0, BSD 3-Clause, - , https://www.h5py.org/, - .

