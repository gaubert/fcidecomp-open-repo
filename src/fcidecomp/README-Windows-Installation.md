# HDF5 JPEG-LS Decompression Plugin for Windows

This project builds the **H5ZJPEGLS** plugin on Windows, allowing HDF5 tools (e.g., `nccopy`, `h5dump`) to decompress JPEG-LS compressed datasets.

---

## 🧰 Prerequisites

- [Visual Studio 2022 Community Edition](https://visualstudio.microsoft.com/)
  - Install "Desktop development with C++" to install CMake
- [CMake] See above
- [vcpkg](https://github.com/microsoft/vcpkg) to install some packages like zlib
- [Git](https://git-scm.com/) or from the powershell of VS Studio
- Pre-built [HDF5 binaries](https://www.hdfgroup.org/downloads/hdf5/)
- [nccopy](https://downloads.unidata.ucar.edu/netcdf/) from the netcdf tools to test it 

---

## 📦 Dependencies

Install Zlib using vcpkg:

```powershell
vcpkg install zlib:x64-windows
```

> Make sure to set `CMAKE_TOOLCHAIN_FILE` during configuration (see below).

### Build CharLS statically

```bash
git clone https://github.com/team-charls/charls.git
cd charls
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
cmake --build build --config Release
```

This produces:
- `charls.lib` (static lib)
- `include/` (headers)

---

## 🛠️ Build the Plugin

From the root of your `fcidecomp` sources:

```powershell
cd src\fcidecomp
mkdir build
cd build
```

Configure with CMake:

```powershell
cmake .. -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_BUILD_TYPE=Release `
  -DBUILD_SHARED_LIBS=OFF `
  -DCHARLS_ROOT="C:/path/to/charls" `
  -DHDF5_ROOT="C:/path/to/hdf5" `
  -DHDF5_INCLUDE_DIRS="C:/path/to/hdf5/include" `
  -DHDF5_LIBRARIES="C:/path/to/hdf5/lib/hdf5.lib;C:/path/to/hdf5/lib/hdf5_cpp.lib" `
  -DCMAKE_TOOLCHAIN_FILE="C:/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake"
  -DCMAKE_INSTALL_PREFIX="C:\Users\User\Dev-Guillaume\libs\Built-H5ZPlugin"
```

Build the plugin:

```powershell
cmake --build . --config Release
```

Install locally:

```powershell
cmake --install . --config Release --prefix "C:/Users/User/Dev-Guillaume/libs/Built-H5ZPlugin"
```

---

## 🧪 Testing the Plugin

Set the plugin path:

```powershell
$env:HDF5_PLUGIN_PATH = "C:\Users\User\Dev-Guillaume\libs\Built-H5ZPlugin\bin"
```

Use `nccopy` to decompress the file:

```powershell
cd C:\Users\User\Dev-Guillaume\libs\hdf5\bin
.
ccopy.exe -F none `
  "C:\Users\User\Dev-Guillaume\W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-FDHSI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20240814081939_IDPFI_OPE_20240814081711_20240814081803_N_JLS_C_0050_0031.nc" `
  a.nc
```

You can then open `a.nc` with tools like `ncdump`, Panoply, or any NetCDF/HDF5-compatible viewer.

---

## ✅ Result

- `H5Zjpegls.dll` plugin correctly decompresses JPEG-LS compressed HDF5 datasets
- Fully tested on Windows with statically linked CharLS and pre-built HDF5

---

## 📁 Directory Structure (Summary)

```
├── libs/
│   ├── charls/
│   │   ├── include/
│   │   └── lib/charls.lib
│   ├── hdf5/
│   │   ├── bin/
│   │   ├── include/
│   │   └── lib/
│   └── Built-H5ZPlugin/
│       └── bin/H5Zjpegls.dll
├── fcidecomp-original-guillaume/
│   └── src/
│       └── fcidecomp/
│           └── build/
```

---

## 📝 Notes

- The plugin assumes the **JPEG-LS compression** used in your files is compliant with what CharLS supports.
- For automated environments, you can script the environment setup and plugin deployment via `.ps1` files or installer tools.
