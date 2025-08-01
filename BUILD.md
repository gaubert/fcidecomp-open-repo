# BUILD the EUMETSAT FCIDECOMP software

This builds and installs the **H5ZJPEGLS** plugin from source code, allowing HDF5 tools (e.g., `nccopy`, `h5dump`) to decompress JPEG-LS compressed datasets.

  - builds the fcidecomp library H5Zjpegls to be used as HDF5 plugin
  - HDF5 plugin is built as a shared library, Position Independent Code, conforming the HDF5 plugin API.  
  - uses cmake, therefore it is quite generic and should work on most recent platforms and versions, 

it has been tested in following 64-bit platforms:

  - RockLinux 8
  - AlmaLinux 9.6
  - Ubuntu Linux (20.04; 22.04)
  - Opensuse Leap 15.04
  - Windows-10/11 


## 🧰 Prerequisites

Fcidecomp is built using cmake as a shared libray from C/C++ source code, following tools are required:

	 -Linux:   gcc/g++; cmake; make 

		 Ubuntu:    sudo apt install build-essential; sudo apt install cmake
		 AlmaLinux: sudo groupinstall "Development Tools"; sudo dnf install cmake

		(e.g. gcc/g++ 11.4.0; cmake 3.15; make 4.3)

	 -Windows: Microsoft Visual Studio Community 2022 Edition, 
		when installing MSVC include: "Desktop development with C++"  (this includes Dev PowerShell, cmake, vcpkg)

		(e.g. cmake 3.31.6-msvc6, C/C++ 19.44)


## 📦 Dependencies

Fcidecomp build dependencies are:  charls-devel, zlib-devel, and hdf5-devel.  

By default, as described here, fcidecomp statically links charls and zlib. Consequently, at run-time only dependency is the plugin mechanism API to hdf5.

It is recommended to build and install them in a temporarilly local directory, in order to have an isolated build for more control and visibility of the results. Moreover this is more robust and will work in most platforms.

Alternatively, if any of this dependencies are pre-installed in the system, the fcidecomp build can also find them (see fcidecomp cmake notes below).


## 🛠️ Build and Install dependencies from Source Code

Following descriptions work for both Linux and Windows, noting following:

	 -at the time of this build, used versions were charls-2.4.2; zlib-1.3.1; hdf5-1.14.6 (it should work with other versions)

	 -Windows 64-bits cmake uses by default:  -G "Visual Studio 17 2022" -A x64 (not included below)
	 -in Windows use Developer Powershell to run cmake
	 -in Windows use windows pathnames, e.g. "C:\Users\tmp"

### charls

Get charls source code zip or tar.gz from...  

   1) download from: https://github.com/team-charls/charls/releases  
   2) or, wget https://github.com/team-charls/charls/archive/refs/tags/v2.4.2.zip -O charls-v2.4.2.z

Unpack or clone the source code under a local directory: e.g.  $HOME/charls-2.4.2

Build and Install static library charls:

	 mkdir $HOME/charls-2.4.2/build
	 cd    $HOME/charls-2.4.2/build

 	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/charls"
	 cmake --build   . --config Release
	 cmake --install . --config Release

	 Note: static charls library is built.

### zlib

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

Get source code zip or tar.gz from...

   1) download from: https://github.com/HDFGroup/hdf5/tree/hdf5_1_14_6
   2) or, wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.6.zip -O hdf5-1.14.6.zip

   Unpack or clone the source code under a local directory: e.g.  $HOME/hdf5-1.14.6


Build and Install hdf5, include static zlib:

	 mkdir $HOME/hdf5-1.14.6/build
	 cd    $HOME/hdf5-1.14.6/build

	 cmake -S .. -B .  
		-DCMAKE_BUILD_TYPE=Release
		-DHDF5_BUILD_SHARED_LIBS=ON 
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DCMAKE_INSTALL_PREFIX="$HOME/.local/hdf5"
		-DHDF5_ENABLE_Z_LIB_SUPPORT=ON 
		-DZLIB_USE_STATIC_LIBS=ON
		-DZLIB_USE_EXTERNAL=ON
		-DCMAKE_INCLUDE_PATH="$HOME/.local/zlib/include"  
		-DCMAKE_LIBRARY_PATH="$HOME/.local/zlib/lib"
		-DHDF5_ENABLE_SZIP_SUPPORT=OFF 
		-DHDF5_BUILD_TOOLS=ON 
		-DHDF5_BUILD_EXAMPLES=OFF 
		-DHDF5_BUILD_TESTS=OFF 
		-DHDF5_BUILD_CPP_LIB=ON 
		-DHDF5_BUILD_FORTRAN=OFF 
 		-DHDF5_ENABLE_PARALLEL=OFF 

	 cmake --build   . --config Release
	 cmake --install . --config Release

	 Notes: ZLIB_USE_EXTERNAL, zlib will be statically linked

## 🛠️ Build and install ``fcidecomp``

Once the dependencies are installed, fcidecomp`can be built 

 Get source code zip or tar.gz:

    1) download from https://gitlab.eumetsat.int/open-source/fcidecomp/
    2) or, wget  https://gitlab.eumetsat.int/open-source/fcidecomp/ ...

   Unpack or clone the source code under a local directory: e.g.  $HOME/fcidecomp-<fcidecomp_tag>

Create build directory:

    mkdir $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build
    cd    $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build

Build and Install fcidecomp:

	 cmake -S .. -B . 
		-DCMAKE_BUILD_TYPE=Release   
		-DBUILD_SHARED_LIBS=OFF   
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DCMAKE_INSTALL_PREFIX="$HOME/.local/fcidecomp" 

		-DCHARLS_ROOT="$HOME/.local/charls"
		-DZLIB_ROOT="$HOME/.local/zlib"
		-DHDF5_ROOT="$HOME/.local/hdf5"

	 cmake --build   . --config Release
	 cmake --install . --config Release

	 When successful, $HOME/.local/fcidecomp/hdf5/lib/plugin (Linux) or $HOME/.local/fcidecomp/hdf5/bin (Windows) contain H5Zjpels plugin

	 Note: BUILD_SHARED_LIBS=OFF will try to link static libraries charls and zlib. 
	 Note: Include CHARLS_ROOT, ZLIB_ROOT, or HDF5_ROOT for specific locations, otherwise cmake will try to find them in default system paths.
	 Note: If -DFETCH=ON is included, then charls and zlib will be fetched from Internet.


Finally, set the environment variable ``HDF5_PLUGIN_PATH`` to the built HDF5 plugin -so that HDF5 and netCDF applications use the plugin. 

 	Linux:

	 export PATH=$PATH:$HOME/.local/hdf5/bin 				# if hdf5 not installed in system
	 export LD_LIBRARY_PATH="$HOME/.local/zlib/lib:$LD_LIBRARY_PATH"        # if zlib not installed in system
	 export HDF5_PLUGIN_PATH=$HOME/.local/fcidecomp/lib/plugin/
	 

	Windows PowerShell:

	  $env:PATH += "$HOME\.local\hdf5\bin"         				#  if not yet done to a hdf5 installation
	  $env:PATH += "$HOME\.local\zlib\bin"         				#  if hdf5 uses shared zlib library
	  $env:HDF5_PLUGIN_PATH = "$HOME\.local\fcidecomp\bin"        

	Windows DOS:

	  set PATH=%PATH%;%USERPROFILE%\.local\hdf5\bin;
          set PATH=%PATH%;%USERPROFILE%\.local\zlib\bin
          set HDF5_PLUGIN_PATH=%USERPROFILE%\.local\fcidecomp\bin

## 🧪 Testing the Installation

	 h5dump $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/fcidecomp-test/data/sample.nc 

	 The test successes if the file is dumped and data is shown properly ( dataset pixel_quality )will show is data --no error).

