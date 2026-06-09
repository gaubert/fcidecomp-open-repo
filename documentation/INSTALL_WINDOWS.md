# Install on Windows

This guide covers Windows 10/11 setup for building and testing fcidecomp.

## Prerequisites

- Visual Studio 2022 with "Desktop development with C++"
- CMake 3.20+ (the CI uses 3.31.x). If you install via Visual Studio, enable the individual component "CMake tools for Windows".
- Developer PowerShell for VS (for building)
- Git for Windows + Git LFS (Git provides `bash.exe` for the test script)
- vcpkg (online installer) (for charls, hdf5, netcdf-c)

## Dependencies with vcpkg (recommended)

Install vcpkg and dependencies (including ncdump tools), (during the installation, first change the directory to C: (in mingw64));

  ```
  git clone https://github.com/microsoft/vcpkg C:\vcpkg
  C:\vcpkg\bootstrap-vcpkg.bat
  C:\vcpkg\vcpkg.exe install charls:x64-windows-static hdf5[cpp,zlib]:x64-windows-static netcdf-c[tools]:x64-windows-static
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
  $env:PATH = "C:\fcidecomp\lib;C:\fcidecomp\hdf5\lib\plugin;C:\vcpkg\installed\x64-windows-static\tools\netcdf-c;C:\vcpkg\installed\x64-windows-static\tools\hdf5;C:\vcpkg\installed\x64-windows-static\tools\hdf5\bin;$env:PATH"
  ```

## Test the installation

Ensure the sample file is present (LFS):

  ```
  git lfs pull -I src/fcidecomp/fcidecomp-test/data/W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-HRFI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20260507092518_IDPFI_OPE_20260507092052_20260507092132_N_JLS_O_0057_0007.nc
  ```
Run the post-install test from Git Bash (or a bash shell):
  ```
  export HDF5_PLUGIN_PATH="/c/fcidecomp/hdf5/lib/plugin"
  export PATH="/c/fcidecomp/lib:/c/fcidecomp/hdf5/lib/plugin:/c/vcpkg/installed/x64-windows-static/tools/netcdf-c:/c/vcpkg/installed/x64-windows-static/tools/hdf5:/c/vcpkg/installed/x64-windows-static/tools/hdf5/bin:$PATH"
  cd /c/path/to/fcidecomp
  ./src/fcidecomp/fcidecomp-test/postInstallationTest.sh
  ```
It succeeds if it prints "*** SUCCESS! ***".

You can also run it via Git Bash directly from the Git installation:

```
  "C:\Program Files\Git\bin\bash.exe" --noprofile --norc -e -o pipefail -lc "cd /c/path/to/fcidecomp && export HDF5_PLUGIN_PATH=/c/fcidecomp/hdf5/lib/plugin && export PATH=/c/fcidecomp/lib:/c/fcidecomp/hdf5/lib/plugin:/c/vcpkg/installed/x64-windows-static/tools/netcdf-c:/c/vcpkg/installed/x64-windows-static/tools/hdf5:/c/vcpkg/installed/x64-windows-static/tools/hdf5/bin:$PATH && ./src/fcidecomp/fcidecomp-test/postInstallationTest.sh"
```

Alternative (native CMD/PowerShell) test script:

```
  set HDF5_PLUGIN_PATH=C:\fcidecomp\hdf5\lib\plugin
  set PATH=C:\fcidecomp\lib;C:\fcidecomp\hdf5\lib\plugin;C:\vcpkg\installed\x64-windows-static\tools\netcdf-c;C:\vcpkg\installed\x64-windows-static\tools\hdf5;C:\vcpkg\installed\x64-windows-static\tools\hdf5\bin;%PATH%
  src\fcidecomp\fcidecomp-test\postInstallationTest.bat
```

Optional CTest hook (runs the same script):

```
  cmake -S src\fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DFCIDECOMP_ENABLE_POSTINSTALL_TEST=ON -DFCIDECOMP_ENABLE_COMPONENT_TESTS=OFF
  cmake --build build --config Release
  ctest --test-dir build --output-on-failure
```

The CTest hook simply sets the required environment variables (notably `HDF5_PLUGIN_PATH`) and runs `postInstallationTest.sh` for you.
