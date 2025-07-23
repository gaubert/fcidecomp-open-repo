# BUILD the EUMETSAT FCIDECOMP software

FCIDECOMP HDF5 plugin build and installation from source code uses cmake, this is quite generic and should work on most recent platforms and software versions of used tools and dependencies, it has been tested in following 64-bit platforms:

  - RockLinux 8
  - AlmaLinux 9.6
  - Ubuntu Linux (20.04; 22.04)
  - Opensuse Leap 15.04
  - Windows-10/11 
  - cygwin-64

## Install pre-requisite packages

Fcidecomp HDF5 plugin is a shared libray built from C/C++ source code. cmake is used to build from source code.

	 -In Linux, install:   gcc/g++; cmake; make 

		 Ubuntu:    sudo apt install build-essential; sudo apt install cmake
		 AlmaLinux: sudo groupinstall "Development Tools"; sudo dnf install cmake

		(versions gcc/g++ 11.4.0; cmake 3.20; make 4.3)

	 -In Windows, install: Microsoft Visual Studio Community 2022 Edition, 
		when installing MSVC include: "Desktop development with C++"  (this includes Dev PowerShell, cmake, vcpkg)

		(cmake 3.31.6-msvc6, C/C++ 19.44)


## Dependencies

Fcidecomp build dependencies:  charls-devel, zlib-devel, and hdf5-devel.  

fcidecomp links statically charls and zlib, at run time only dependency is the plugin mechanism API to hdf5.

For simplicity in for the purpose of building fcidecomp, these dependencies are also built here as shown in the subsections below. 


## Build and user-local Install dependencies from Source Code

Following descriptions work for both Linux and Windows, noting following:

	 -at the time of this build, used versions were charls-2.4.2; zlib-1.3.1; hdf5-1.14.6 (it should work with other versions)

	 -Windows 64-bits cmake uses by default of:  -G "Visual Studio 17 2022" -A x64 (include if necessary)
	 -in Windows use Developer Powershell to run cmake
	 -in Windows use windows pathnames, e.g. "C:\Users\tmp"

### Charls

Get charls source code zip or tar.gz from...  

   1) download from: https://github.com/team-charls/charls/releases  
   2) or, wget https://github.com/team-charls/charls/archive/refs/tags/v2.4.2.zip -O charls-v2.4.2.z

Unpack or clone the source code under a local directory: e.g.  $HOME/charls-2.4.2

Build and Install static CharLS:

	 mkdir $HOME/charls-2.4.2/build
	 cd    $HOME/charls-2.4.2/build

 	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/charls"
	 cmake --build   . --config=Release
	 cmake --install . --config=Release


### zlib

Get zlib source code zip or tar.gz from...

   1) download from: https://zlib.net/  (1.3.1):   
   2) or, wget https://github.com/madler/zlib/archive/refs/tags/v1.3.1.zip -O zlib-1.3.1.zip

Unpack or clone the source code under a local directory: e.g.  $HOME/zlib-1.3.1


Build and Install:


	 mkdir $HOME/zlib-1.3.1/build
	 cd    $HOME/zlib-1.3.1/build

	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local/zlib"
	 cmake --build   . --config=Release
	 cmake --install . --config=Release


### hdf5

Get source code zip or tar.gz from...

   1) download from: https://github.com/HDFGroup/hdf5/tree/hdf5_1_14_6
   2) or, wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.6.zip -O hdf5-1.14.6.zip

   Unpack or clone the source code under a local directory: e.g.  $HOME/hdf5-1.14.6


Build and Install:

	 mkdir $HOME/hdf5-1.14.6/build
	 cd    $HOME/hdf5-1.14.6/build

	 cmake -S .. -B .  
		-DCMAKE_BUILD_TYPE=Release
		-DHDF5_BUILD_SHARED_LIBS=ON 
		-DHDF5_ENABLE_Z_LIB_SUPPORT=ON 
		-DZLIB_ROOT="$HOME/.local/zlib"
		-DHDF5_ENABLE_SZIP_SUPPORT=OFF 
		-DCMAKE_INSTALL_PREFIX="$HOME/.local/hdf5"
		-DHDF5_BUILD_TOOLS=ON 
		-DHDF5_BUILD_EXAMPLES=OFF 
		-DHDF5_BUILD_TESTS=OFF 
		-DHDF5_BUILD_CPP_LIB=ON 
		-DHDF5_BUILD_FORTRAN=OFF 
 		-DHDF5_ENABLE_PARALLEL=OFF 
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON

	 cmake --build   . --config=Release
	 cmake --install . --config=Release

## Build and install ``fcidecomp``

Once the dependencies are built and installed, ``fcidecomp`` can be built 

 Get source code zip or tar.gz:

    1) download from https://gitlab.eumetsat.int/open-source/fcidecomp/
    2) or, wget  https://gitlab.eumetsat.int/open-source/fcidecomp/ ...

   Unpack or clone the source code under a local directory: e.g.  $HOME/fcidecomp-<fcidecomp_tag>

Create build directory:

    mkdir $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build
    cd    $HOME/fcidecomp-<fcidecomp_tag>/src/fcidecomp/build

Build and Install:

	 cmake -S .. -B . 
		-DCMAKE_BUILD_TYPE=Release   
		-DBUILD_SHARED_LIBS=OFF   
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DCMAKE_INSTALL_PREFIX="$HOME/.local/fcidecomp" 

		-DCHARLS_ROOT="$HOME/.local/charls"
		-DZLIB_ROOT="$HOME/.local/zlib"
		-DHDF5_ROOT="$HOME/.local/hdf5"

	 cmake --build   . --config=Release
	 cmake --install . --config=Release

	 Note: if any of charls, zlib and/or hdf5 are installed in default system paths and you want to use them, you don't need to specify those variables, cmake will find them. Otherwise specify their location. 

Finally, set the environment variable ``HDF5_PLUGIN_PATH`` to the built HDF5 plugin -so that HDF5 and netCDF applications use the plugin. 

 	Linux:

	 export PATH=$PATH:$HOME/.local/hdf5/bin
	 export HDF5_PLUGIN_PATH=$HOME/.local/fcidecomp/lib/plugin/
	 

	Windows:

	 $env:PATH += "$HOME\.local\hdf5\bin"         				#  if not yet done to a hdf5 installation
	 $env:HDF5_PLUGIN_PATH = "$HOME\.local\fcidecomp\bin"        


