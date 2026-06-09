# Install on Windows

This guide covers Windows 10/11 setup for building and testing fcidecomp. In GitHub Actions, the Windows CI job is pinned to `windows-2025-vs2026` to match the current hosted-runner migration.

## Prerequisites

- Visual Studio 2022 or newer with "Desktop development with C++"
- CMake 3.20+ (the CI uses 3.31.x). If you install via Visual Studio, enable the individual component "CMake tools for Windows".
- Developer PowerShell for VS (for building)
- Git LFS
- vcpkg (online installer) (for charls, hdf5, netcdf-c)

## Dependencies with vcpkg (recommended)

Install vcpkg and dependencies (including ncdump tools), (during the installation, first change the directory to C: (in mingw64));

  ```
  git clone https://github.com/microsoft/vcpkg C:\vcpkg
  C:\vcpkg\bootstrap-vcpkg.bat
  C:\vcpkg\vcpkg.exe install charls:x64-windows-static hdf5[cpp,tools,zlib]:x64-windows-static netcdf-c[tools]:x64-windows-static
  ```
P.S.: vcpkg needs a complete VS installation 

## Build and install fcidecomp

The fcidecomp needs to be downloaded first, and the cmakelist.txt file address needs to be specified accordingly

From a Developer PowerShell:

  ```
  cmake -S src\fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows-static -DCHARLS_ROOT=C:\vcpkg\installed\x64-windows-static
  cmake --build build --config Release
  cmake --install build --config Release --prefix C:\fcidecomp
  ```

The plugin is installed to:

  ```
  C:\fcidecomp\hdf5\lib\plugin\
  C:\fcidecomp\lib\
  ```
Set environment variables (PowerShell):
  
  ```
  $env:HDF5_PLUGIN_PATH = "C:\fcidecomp\hdf5\lib\plugin"
  $env:PATH = "C:\fcidecomp\lib;C:\fcidecomp\hdf5\lib\plugin;C:\vcpkg\installed\x64-windows-static\tools\netcdf-c;C:\vcpkg\installed\x64-windows-static\tools\hdf5;$env:PATH"
  ```

## Test the installation

Ensure the sample file is present (LFS):

  ```
  git lfs pull -I src/fcidecomp/fcidecomp-test/data/W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-HRFI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20260507092518_IDPFI_OPE_20260507092052_20260507092132_N_JLS_O_0057_0007.nc
  ```
Run the native Windows test script from CMD or PowerShell:

```
  set HDF5_PLUGIN_PATH=C:\fcidecomp\hdf5\lib\plugin
  set PATH=C:\fcidecomp\lib;C:\fcidecomp\hdf5\lib\plugin;C:\vcpkg\installed\x64-windows-static\tools\netcdf-c;C:\vcpkg\installed\x64-windows-static\tools\hdf5;%PATH%
  src\fcidecomp\fcidecomp-test\postInstallationTest.bat
```

In PowerShell, set the same variables as:

```
  $env:HDF5_PLUGIN_PATH = "C:\fcidecomp\hdf5\lib\plugin"
  $env:PATH = "C:\fcidecomp\lib;C:\fcidecomp\hdf5\lib\plugin;C:\vcpkg\installed\x64-windows-static\tools\netcdf-c;C:\vcpkg\installed\x64-windows-static\tools\hdf5;$env:PATH"
  cmd /c "src\fcidecomp\fcidecomp-test\postInstallationTest.bat"
```

It succeeds if it prints "*** SUCCESS! ***".

Optional CTest hook:

```
  cmake -S src\fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DFCIDECOMP_ENABLE_POSTINSTALL_TEST=ON -DFCIDECOMP_ENABLE_COMPONENT_TESTS=OFF
  cmake --build build --config Release
  ctest --test-dir build --output-on-failure
```

On Windows, the CTest hook runs `postInstallationTest.bat`. On non-Windows platforms it runs `postInstallationTest.sh`.
