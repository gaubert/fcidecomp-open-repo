# Install on Linux

This guide covers Linux setup for building and testing fcidecomp on Ubuntu.

For AlmaLinux, refer to the Linux CI (target job build-almalinux) and the workflow definition:
- [ci-linux actions](https://github.com/gaubert/fcidecomp-open-repo/actions/workflows/ci-linux.yml)
- [ci-linux workflow](../.github/workflows/ci-linux.yml)

## Prerequisites

- Build tools: gcc/g++, make, cmake
- Git + Git LFS (for sample data)
- Optional for testing: netcdf tools (ncdump)

Ubuntu:

```sudo apt update
  sudo apt install build-essential cmake git-lfs
  sudo apt install zlib1g-dev libhdf5-dev hdf5-tools netcdf-bin
```

AlmaLinux:

```sudo dnf install epel-release
  sudo dnf groupinstall "Development Tools"
  sudo dnf install cmake git-lfs
  sudo dnf install zlib zlib-devel hdf5 hdf5-devel
```

## Dependencies from packages

If your distro provides them, install zlib and hdf5 from the package manager (Ubuntu or AlmaLinux). CharLS should be built from source to ensure a static library.

## Build dependencies from source (CharLS, zlib, hdf5)

CharLS:

Download the source: https://github.com/team-charls/charls/releases

  ```mkdir $HOME/charls-2.4.2/build
  cd $HOME/charls-2.4.2/build
  cmake -S .. -B . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/charls"
  cmake --build . --config Release
  cmake --install . --config Release
  ```

zlib (optional from source):

Download the source: https://zlib.net/ or https://github.com/madler/zlib/releases

  ```mkdir $HOME/zlib-1.3.1/build
  cd $HOME/zlib-1.3.1/build
  cmake -S .. -B . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/zlib"
  cmake --build . --config Release
  cmake --install . --config Release
  ```

hdf5 (optional from source):

Download the source: https://www.hdfgroup.org/downloads/hdf5/

  ```mkdir $HOME/hdf5-1.14.6/build
  cd $HOME/hdf5-1.14.6/build
  cmake -S .. -B . -DCMAKE_BUILD_TYPE=Release -DHDF5_BUILD_SHARED_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/hdf5" -DHDF5_ENABLE_Z_LIB_SUPPORT=ON -DZLIB_USE_STATIC_LIBS=ON -DZLIB_ROOT="$HOME/.local/zlib" -DHDF5_ENABLE_SZIP_SUPPORT=OFF -DHDF5_BUILD_TOOLS=ON -DHDF5_BUILD_EXAMPLES=OFF -DHDF5_BUILD_TESTS=OFF -DHDF5_BUILD_CPP_LIB=ON -DHDF5_BUILD_FORTRAN=OFF -DHDF5_ENABLE_PARALLEL=OFF
  cmake --build . --config Release
  cmake --install . --config Release
  ```

## Build and install fcidecomp

  ```cd $HOME/fcidecomp-<tag>/src/fcidecomp
  INSTALL_PREFIX="$HOME/.local/fcidecomp"
  cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" -DCHARLS_ROOT="$HOME/.local/charls"
  cmake --build build --config Release
  cmake --install build --config Release --prefix "$INSTALL_PREFIX"
  ```

The plugin is installed to:

  ```
  $INSTALL_PREFIX/hdf5/lib/plugin
  ```

Set environment variables:

  ```export HDF5_PLUGIN_PATH="$INSTALL_PREFIX/hdf5/lib/plugin"
  export PATH="$HOME/.local/hdf5/bin:$PATH"                       # if hdf5 not installed in system
  export LD_LIBRARY_PATH="$HOME/.local/zlib/lib:$LD_LIBRARY_PATH" # if zlib not installed in system
  ```

## Test the installation

Ensure the sample file is present (LFS):

  ```
  git lfs pull -I src/fcidecomp/fcidecomp-test/data/sample.nc
  ```

Run the post-install test:

  ```
  export HDF5_PLUGIN_PATH="$INSTALL_PREFIX/hdf5/lib/plugin"
  ./src/fcidecomp/fcidecomp-test/postInstallationTest.sh
  ```

It succeeds if it prints ```"*** SUCCESS! ***".```

Optional CTest hook:

  ```
  cmake -S src/fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DFCIDECOMP_ENABLE_POSTINSTALL_TEST=ON -DFCIDECOMP_ENABLE_COMPONENT_TESTS=OFF
  cmake --build build --config Release
  ctest --test-dir build --output-on-failure
  ```

The CTest hook simply sets the required environment variables (notably `HDF5_PLUGIN_PATH`) and runs `postInstallationTest.sh` for you.
