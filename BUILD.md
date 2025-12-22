# BUILD the EUMETSAT FCIDECOMP software

This describes the build and install of the **H5ZJPEGLS** HDF5 filter plugin from source code.

  - builds the fcidecomp library H5Zjpegls to be used as HDF5 filter plugin
  - HDF5 filter plugin is built as a shared library (PIC), conforming to HDF5 filter plugin API
  - uses cmake, therefore it is quite generic and should work on most recent Operating Systems

it has been tested in following 64-bit Operating Systems:

  - RockLinux 8
  - AlmaLinux 9.6
  - Ubuntu Linux (20.04; 22.04)
  - Opensuse Leap 15.04
  - Windows-10/11 

Platform-specific install guides:
  - documentation/INSTALL_LINUX.md
  - documentation/INSTALL_WINDOWS.md
  - documentation/INSTALL_MACOS.md


## 🧰 Prerequisites

Fcidecomp is built using cmake as a shared libray from C/C++ source code, following tools are required:

	 -Linux: gcc/g++; cmake; make
	 -Windows: Visual Studio 2022 with "Desktop development with C++" (includes Developer PowerShell, cmake, vcpkg)

For detailed platform instructions, see:
  - documentation/INSTALL_LINUX.md
  - documentation/INSTALL_WINDOWS.md
  - documentation/INSTALL_MACOS.md

## 📦 Dependencies

Fcidecomp build required dependencies are:  charls, zlib, and hdf5, they can be found as standard packages or can be built and installed from source code:

	-charls can be built from source (Linux), or installed via package managers (Windows vcpkg, macOS Homebrew).
	-hdf5 and zlib can be installed from packages or built from source.


## 🛠️ Install dependencies from packages

If not already installed in the system, zlib-devel and hdf5-devel can be installed from packages. Charls is not found as pre-built package.

See the platform guides above for package manager steps.


## 🛠️ Build and Install dependencies from Source Code


Following descriptions work for Linux (and other Unix-like systems):

	 -at the time of this build, used versions were charls-2.4.2; zlib-1.3.1; hdf5-1.14.6 (it should work with other recent versions)

### charls

fcidecomp builds charls from source code making sure that the charls static library is built. (to be linked statically and avoid runtime dependencies).

Get charls source code zip or tar.gz from the releases page and pick the latest package (currently 2.4.2):  

   1) browse to https://github.com/team-charls/charls/releases and download the latest package  
   2) or use wget/curl with the package link shown on that page (e.g. the current tag archive) to save locally

Unpack or clone the source code under a local directory: e.g.  $HOME/charls-2.4.2

Build and Install static library charls:

	 mkdir $HOME/charls-2.4.2/build
	 cd    $HOME/charls-2.4.2/build

 	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/charls"
	 cmake --build   . --config Release
	 cmake --install . --config Release

	 Note: static charls library is built.

### zlib

fcidecomp uses the standard zlib-devel package. If there is no pre-built zlib package for the O.S. following installation from source code can be done.

Get zlib source code zip or tar.gz from...

   1) download from: https://zlib.net/  (1.3.1):   
   2) or, wget https://github.com/madler/zlib/archive/refs/tags/v1.3.1.zip -O zlib-1.3.1.zip

Unpack or clone the source code under a local directory: e.g.  $HOME/zlib-1.3.1


Build and Install static library zlib:


	 mkdir $HOME/zlib-1.3.1/build
	 cd    $HOME/zlib-1.3.1/build

	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/zlib"
	 cmake --build   . --config Release
	 cmake --install . --config Release

	 Note: static zlib library is built.
	 Note: zlib is also needed to build hdf5.

### hdf5

fcidecomp uses the standard hdf5 package. If there is no pre-built hdf5 package for the O.S. following installation from source code can be used (note that cmake variables can slightly vary depending on OS).

Get source code zip or tar.gz from...

   1) download from: https://github.com/HDFGroup/hdf5/tree/hdf5_1_14_6
   2) or, wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.6.zip -O hdf5-1.14.6.zip

   Unpack or clone the source code under a local directory: e.g.  $HOME/hdf5-1.14.6


Build and Install hdf5, include static zlib:

	 mkdir $HOME/hdf5-1.14.6/build
	 cd    $HOME/hdf5-1.14.6/build

	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release -DHDF5_BUILD_SHARED_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/hdf5" -DHDF5_ENABLE_Z_LIB_SUPPORT=ON -DZLIB_USE_STATIC_LIBS=ON -DZLIB_ROOT="$HOME/.local/zlib"  -DHDF5_ENABLE_SZIP_SUPPORT=OFF -DHDF5_BUILD_TOOLS=ON -DHDF5_BUILD_EXAMPLES=OFF -DHDF5_BUILD_TESTS=OFF -DHDF5_BUILD_CPP_LIB=ON -DHDF5_BUILD_FORTRAN=OFF -DHDF5_ENABLE_PARALLEL=OFF 

	 cmake --build   . --config Release
	 cmake --install . --config Release

	 Notes: This will try to link with static zlib, if existing. 
	 Notes: use DZLIB_ROOT or following
	        	-DCMAKE_INCLUDE_PATH="$HOME/.local/zlib/include"  
			-DCMAKE_LIBRARY_PATH="$HOME/.local/zlib/lib"

## 🛠️ Build and Install ``fcidecomp``

Once the dependencies are installed, fcidecomp`can be built 

 Get source code zip or tar.gz:

    1) download from https://gitlab.eumetsat.int/open-source/fcidecomp/
    2) or, wget  https://gitlab.eumetsat.int/open-source/fcidecomp/ ...

   Unpack or clone the source code under a local directory: e.g.  $HOME/fcidecomp-<fcidecomp_tag>

Create build directory:

    mkdir $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build
    cd    $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build

Build and Install fcidecomp:

	 INSTALL_PREFIX="$HOME/.local/fcidecomp"

	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release   -DBUILD_SHARED_LIBS=OFF   -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" -DCHARLS_ROOT="$HOME/.local/charls"


	 cmake --build   . --config Release
	 cmake --install . --config Release --prefix "$INSTALL_PREFIX"    # defaults to /usr/local if --prefix/variable omitted

	 When successful, $HOME/.local/fcidecomp/hdf5/lib/plugin (Linux/macOS) or $HOME/.local/fcidecomp/hdf5/bin (Windows) contain H5Zjpels plugin.

	 Note: BUILD_SHARED_LIBS=OFF will try to link static libraries charls and zlib.
	 Note: macOS uses BUILD_SHARED_LIBS=ON when linking against Homebrew charls (see documentation/INSTALL_MACOS.md).
	 Note: Include ZLIB_ROOT, or HDF5_ROOT for specific locations, otherwise cmake will try to find them in default system paths.
		-DZLIB_ROOT="$HOME/.local/zlib"     			
		-DHDF5_ROOT="$HOME/.local/hdf5"			


Finally, set the environment variable ``HDF5_PLUGIN_PATH`` to the built HDF5 plugin -so that HDF5 and netCDF applications use the plugin. 

 	Linux:

	 export PATH=$PATH:$HOME/.local/hdf5/bin 				# if hdf5 not installed in system
	 export LD_LIBRARY_PATH="$HOME/.local/zlib/lib:$LD_LIBRARY_PATH"        # if zlib not installed in system
	 export HDF5_PLUGIN_PATH=$HOME/.local/fcidecomp/hdf5/lib/plugin/        # replace with $INSTALL_PREFIX if using a different location
	 

	Windows PowerShell:

	  $env:PATH += "$HOME\.local\hdf5\bin"         				#  if not yet done to a hdf5 installation
	  $env:PATH += "$HOME\.local\zlib\bin"         				#  if hdf5 uses shared zlib library
	  $env:HDF5_PLUGIN_PATH = "$HOME\.local\fcidecomp\bin"        

	Windows DOS:

	  set PATH=%PATH%;%USERPROFILE%\.local\hdf5\bin;
          set PATH=%PATH%;%USERPROFILE%\.local\zlib\bin
	  set HDF5_PLUGIN_PATH=%USERPROFILE%\.local\fcidecomp\bin

## 🧪 Testing the Installation

Ensure the test data are available (fetch via ``git lfs pull`` if the repository uses LFS) and that ``ncdump`` is installed (e.g. ``apt-get install netcdf-bin`` on Debian/Ubuntu). Then run:

  git lfs pull -I src/fcidecomp/fcidecomp-test/data/sample.nc   # download test NetCDF if stored in LFS

  export HDF5_PLUGIN_PATH=$HOME/.local/fcidecomp/hdf5/lib/plugin/   # or your INSTALL_PREFIX
  ./src/fcidecomp/fcidecomp-test/postInstallationTest.sh

The script runs ``ncdump`` on ``sample.nc`` with the plugin enabled and compares against the reference output. It succeeds if it prints ``*** SUCCESS! ***``.

### Running the post-install test via CTest (optional)

Enable the CTest hook during configure and run ``ctest`` from the build directory. To only run the post-install smoke test (and skip the component/unit tests that compare generated HDF5 files to references), leave ``FCIDECOMP_ENABLE_COMPONENT_TESTS`` at its default ``OFF``:

  cmake -S src/fcidecomp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DFCIDECOMP_ENABLE_POSTINSTALL_TEST=ON -DFCIDECOMP_ENABLE_COMPONENT_TESTS=OFF
  cmake --build build --config Release
  ctest --test-dir build --output-on-failure

Notes:
- The CTest rule sets ``HDF5_PLUGIN_PATH`` to the built plugin directory (``build/fcicomp-H5Zjpegls``). Use ``ctest --output-on-failure`` to see the script output.
- ``ncdump`` must be on ``PATH`` (install via your package manager, e.g. ``netcdf-bin`` on Debian/Ubuntu).
- If the repository uses Git LFS, ensure ``git lfs pull -I src/fcidecomp/fcidecomp-test/data/sample.nc`` has been run before ``ctest`` so ``sample.nc`` is present.
