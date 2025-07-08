
# Building and Testing H5Z JPEG-LS Plugin on Linux

This guide explains how to build and test the HDF5 plugin for JPEG-LS decompression using CharLS and HDF5, with all dependencies built statically.

---

## Prerequisites

- CMake ≥ 3.10
- A C/C++ compiler (e.g., gcc/g++)
- HDF5 (built or installed)
- CharLS (statically built)
- NetCDF tools (`nccopy` for testing)

---

## 1. Build CharLS Statically

```bash
git clone https://github.com/team-charls/charls.git
cd charls
cmake -S . -B build \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/your/target/install/path
cmake --build build --target install
```

---

## 2. Configure and Build the Plugin

Assuming CharLS and HDF5 are already installed:

```bash
export CHARLS_ROOT=/path/to/charls
export HDF5_ROOT=/path/to/hdf5

mkdir build && cd build

cmake .. \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCHARLS_ROOT=$CHARLS_ROOT \
  -DHDF5_ROOT=$HDF5_ROOT \
  -DCMAKE_INSTALL_PREFIX=/desired/install/path

make -j$(nproc)
make install
```

---

## 3. Test with `nccopy`

```bash
export HDF5_ROOT=/desired/install/path/of/hdf5
export HDF5_PLUGIN_PATH=/desired/install/path/lib/plugin
export NETCDF_HOME=/desired/install/path/of/netcdf

nccopy -F none /path/to/compressed.nc decompressed.nc
```

This command decompresses the NetCDF file using the HDF5 plugin. The `-F none` option removes filters (like compression) from the output.

If it runs silently and produces `decompressed.nc`, the plugin is working.

---

## Notes

- No need to install `zlib` separately for this plugin.
- You can optionally script the environment setup and test with a shell script.

