
## Using the ``fcidecomp`` software

Once built and installed, the ``fcidecomp`` library, HDF5 filter plugin H5ZJPEGLS, can be used in different ways as described in following sections.

### Use with netCDF4-C tools

- make sure netCDF tools are installed
- set ``HDF5_PLUGIN_PATH`` environment to the directory containing the plugin. (see `BUILD` file).

Note that the fcidecomp conda environment (see `CONDA` file) already contains netCDF tools and the plugin configuration.

#### Example with ``nccopy``

netCDF4-C tools use fcidecomp plugin in $HDF5_PLUGIN_PATH to decompress JPEG-LS compressed netCDF files. For example, to decompress a file using `nccopy`, run the following line:

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

    for conda fcidecomp created environment: 

    - in Linux (conda install), corresponds to `$PATH_TO_CONDA_ENV/lib` 
      with `$PATH_TO_CONDA_ENV` equal to the path to the `conda` environment in which `fcidecomp` is installed.
    - in Windows (conda install), corresponds to `$PATH_TO_CONDA_ENV\Library\lib`
      with `$PATH_TO_CONDA_ENV` equal to the path to the `conda` environment in which `fcidecomp` is installed.

Tested with ToolsUI 5.5.3 on Windows, Panoply 5.1.1 on Linux (known as not working for Panoply for that version in Windows due to a 
Panoply issue).

### Use with python

export HDF5_PLUGIN_PATH=/path/to/your/plugin/directory

python fcidecomp_ex.py
	 
where fcidecomp_ex.py is:
	 
	 import netCDF4
	 import numpy as np
	 
	 # The NetCDF file that was created using fcicomp.
	 NETCDF_FILE = 'fcidecomp_sample.nc'
	 
	 try:
	     # Open the NetCDF file for reading.
	     # The 'r' mode is sufficient. No special flags or arguments are needed to decompress.
	     with netCDF4.Dataset(NETCDF_FILE, 'r') as nc_file:
	         # Access the variable that contains the compressed data (in this case pixel_quality).
	         variable = nc_file.variables['pixel_quality']
	 
	         # Read the entire dataset into a NumPy array.
	         # The HDF5 library will call your plugin to decompress the data as it's read.
	         data_read = variable[:]
	 
	         print(f"Successfully read data of shape: {data_read.shape}")
	         print("Data type:", data_read.dtype)
	         
	         # Optional: Print some metadata to confirm the filter was used.
	         # This shows the filter ID, which is stored in the file's metadata.
	         filter_id = variable._filters['id']
	         print(f"The variable was compressed with filter ID: {filter_id}")
	 
	 except FileNotFoundError:
	     print(f"Error: The file '{NETCDF_FILE}' was not found.")
	 except KeyError:
	     print("Error: The variable 'pixel_quality' was not found in the file.")
	 except RuntimeError as e:
	     # This might indicate that the HDF5 library failed to load the plugin.
	     print(f"A runtime error occurred. This could mean the HDF5 filter plugin path is incorrect or the plugin is faulty. Error details: {e}")
	 

### Use with Conda: `h5py`-based Python libraries.

Once the `hdf5plugin` Conda package is installed, use of the ``fcidecomp`` decompression libraries should be automatically enabled for `h5py`-based Python libraries.

```python
import netCDF4
import hdf5plugin  # noqa: F401

ds = netCDF4.Dataset("src/fcidecomp/fcidecomp-test/data/sample.nc", "r")
print(list(ds.variables.keys()))
print(ds.variables["effective_radiance"][0, 0])
ds.close()
```

Now every `h5py`-based Python library, such as `xarray`, will be able to open and read JPEG-LS compressed files without 
further steps.

For more information on the Python installation, please refer to [documentation/PYTHON_INSTALLATION.md](./documentation/PYTHON_INSTALLATION.md).
