# EUMETSAT ``fcidecomp`` software

The ``fcidecomp`` software enables decompression of JPEG-LS netCDF files. 

It is used as a hdf5 plugin for hdf5/netcdf files, it can be used in any environment being able to use hdf5 plugins: 

   -netCDF-C tools 
   -netCDF-Java tools
   -Conda/Python (prebuilt fcidecomp conda pacakge) 

The EUMETSAT Data-Tailor also provides a customisation with this plugin.

## Supported platforms and installation

The ``fcidecomp`` software is a C++ library hdf5 plugin which can be built and installed on multiple O.S. 

Following 64-bit platforms have been tested:

- RockyLinux 8 
- AlmaLinux 9 
- Linux Ubuntu (18.04; 20.04 22.04) 
- Windows (10; 11)

For building and installing the hdf5 plugin see BUILD.md file.


For installing fcidecomp under conda (with pre-built conda fcidecomp package) see CONDA.md file.


## Using the ``fcidecomp`` software

The ``fcidecomp`` library can be used in different ways as described in following sections.

### Use with netCDF4-C tools

### Prerequisites

- make sure netCDF tools are installed
- set ``HDF5_PLUGIN_PATH`` environment to the directory containing the plugin. (see `BUILD` file).

Note that the conda created environment (see `CONDA` file) already contains netCDF tools and the plugin.

### Example with ``nccopy``

netCDF4-C tools will use fcidecomp plugin in $HDF5_PLUGIN_PATH to decompress JPEG-LS compressed netCDF files. For example, to decompress a file using `nccopy`, run the following line:

    nccopy -F none $PATH_TO_COMPRESSED_FILE $PATH_TO_DECOMPRESSED_FILE

where:

- `$PATH_TO_COMPRESSED_FILE` is the path to the JPEG-LS compressed file
- `$PATH_TO_DECOMPRESSED_FILE` is the path where the decompressed file should be saved


### Use with netCDF-Java based tools

With netCDF-Java versions greater than 5.5.2, it is possible to open JPEG-LS compressed netCDFs with netCDF-Java based 
tools, such as toolsUI and Panoply, instructing netCDF-Java to use the netCDF-C library for reading purposes. 
To enable this feature:

1. install the netCDF4 library package
2. ensure the file `$HOME/.unidata/nj22Config.xml` exists (if it doesn't, it should be created) and 
   that it contains the following lines:

        <nj22Config>
          <Netcdf4Clibrary>
            <libraryPath>$PATH_TO_NETCDF_LIB_DIR</libraryPath>
            <libraryName>netcdf</libraryName>
            <useForReading>true</useForReading>
          </Netcdf4Clibrary>
        </nj22Config>

    where `$PATH_TO_NETCDF_LIB_DIR` is the path to the directory containing the `netcdf4` library, which:

    for plugin library:
    - in RockyLinux (install from source), corresponds to `/usr/lib64`
    - in Ubuntu 20.04 (install from source), corresponds to `/usr/lib/x86_64-linux-gnu/`

    for conda created environment: 

    - in Linux (conda install), corresponds to `$PATH_TO_CONDA_ENV/lib` 
      with `$PATH_TO_CONDA_ENV` equal to the path to the `conda` environment in which `fcidecomp` is installed.
    - in Windows (conda install), corresponds to `$PATH_TO_CONDA_ENV\Library\lib`
      with `$PATH_TO_CONDA_ENV` equal to the path to the `conda` environment in which `fcidecomp` is installed.

Tested with ToolsUI 5.5.3 on Windows, Panoply 5.1.1 on Linux (known as not working for Panoply for that version in Windows due to a 
Panoply issue).


### Use with Conda: `h5py`-based Python libraries.

Once the `fcidecomp` Conda package is installed and the Conda environment in which it is installed is activated (see CONDA.md),
use of the ``fcidecomp`` decompression libraries should be automatically enabled for `h5py`-based Python libraries.

To ensure the ``fcidecomp`` filter is loaded, in a Python shell execute:

    import fcidecomp
    
Now every `h5py`-based Python library, such as `xarray`, will be able to open and read JPEG-LS compressed files without 
further steps.


### Use with the EUMETSAT Data-Tailor software

A plugin enabling the decompression of JPEG-LS Meteosat Third Generation (MTG) products via the ``fcidecomp`` software is
available for the EUMETSAT Data-Tailor software. For further information, refer to the README of its [public GitLab
repository](<https://gitlab.eumetsat.int/open-source>) and the dedicated EUMETSAT confluence page which, once created,
will be a subpage of the [Installing or removing customisation plugins](<https://eumetsatspace.atlassian.net/wiki/spaces/DSDT/pages/378273985/Installing+or+removing+customisation+plugins>)
page.

Inventory Notices
-----------------

Licenses and copyright information for software dependencies up to version 2.0.0
is documented within the ``inventory`` folder.

Files listed under `inventory/items/data_proprietary.ABOUT` are licensed under EUMETSAT Proprietary license.

#### Dependencies
The following dependencies are not included in the package but are required and they will be downloaded at build or compilation time:
* component name, version, SPDX license id, copyright, home_url, comments
* charls, 2.1.0, BSD 3-Clause, - , https://github.com/team-charls/charls, - .
* hdf5, 1.12.* to 1.14.*, BSD 3-Clause, - , https://www.h5py.org/, - .
* h5py, 2.* and 3.6.0, BSD 3-Clause, - , https://www.h5py.org/, - .
* python, 3.9 to 3.12, see https://docs.python.org/3/license.html, - , https://www.python.org/, - .
* zlib, 1.2.13, zlib (http://zlib.net/zlib_license.html), - , https://zlib.net/, - .
* libnetcdf, 4.8.1, MIT , - , https://www.unidata.ucar.edu/software/netcdf/, - .
* libssh2, 1.10.0, - , see https://www.libssh2.org/license.html , https://www.libssh2.org/, - .
* netcdf4, 1.6.2, -, - , https://unidata.github.io/netcdf4-python/, - .

