# Python Installation

This page describes two ways to use FCIDECOMP from Python.

## Option 1: Use the `hdf5plugin` package (recommended for Python-only use)

This installs prebuilt HDF5 filter plugins and configures `h5py` automatically.

Install:

```
python -m pip install hdf5plugin h5py netCDF4
```

Example using Satpy (see the Satpy FCI L1C natural color example for context):
https://satpy.readthedocs.io/en/latest/examples/fci_l1c_natural_color.html

Minimal test:

```
python - <<'PY'
import h5py
import hdf5plugin  # noqa: F401

f = h5py.File("src/fcidecomp/fcidecomp-test/data/sample.nc", "r")
print(list(f.keys()))
print(f["effective_radiance"][0, 0])
f.close()
PY
```

## Option 2: Build the FCIDECOMP plugin and set `HDF5_PLUGIN_PATH`

Build the plugin from source (see the platform install guides). Then set the plugin path and use Python.

Example:

```
export HDF5_PLUGIN_PATH="$HOME/.local/fcidecomp/hdf5/lib/plugin"
python - <<'PY'
import netCDF4

ds = netCDF4.Dataset("src/fcidecomp/fcidecomp-test/data/sample.nc", "r")
print("variables:", list(ds.variables.keys()))
print("effective_radiance[0,0]:", ds.variables["effective_radiance"][0, 0])
ds.close()
PY
```

You can also run the packaged validator script:

```
export HDF5_PLUGIN_PATH="$HOME/.local/fcidecomp/hdf5/lib/plugin"
python src/fcidecomp/fcidecomp-test/verify_sample_nc.py
```
