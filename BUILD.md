# BUILD the EUMETSAT FCIDECOMP software

This describes how to build and install the EUMETSAT FCIDECOMP HDF5 plugin from the source code [from the source code](#build-and-installation-from-the-source-code).

FCIDECOMP HDF5 plugin build and installation uses cmake. It works on most platforms, it has been tested in following 64-bit platforms:

  - RockLinux 8
  - AlmaLinux 9.6
  - Ubuntu Linux 20.04
  - Ubuntu Linux 22.04
  - Ubuntu  Linux 22.04
  - Opensuse Leap 15.04

  - Windows-10/11 64-bits
  
  - cygwin-64

## Install pre-requisite packages

Fcidecomp HDF5 plugin is C/C++ code, cmake is used to build from source code.  

   -In Linux, install:   gcc/g++; cmake; make 

		Ubuntu:    sudo apt install build-essential; sudo apt install cmake
                AlmaLinux: sudo groupinstall "Development Tools"; sudo dnf install cmake

		(versions gcc/g++ 11.4.0; cmake 3.20; make 4.3)

			

   -In Windows, install: Visual Studio Community 2022 Edition, 
			-when installing include: "Desktop development with C++"  
			-it includes Dev PowerShell, cmake, vcpkg
			(cmake 3.31.6-msvc6, C/C++ 19.44) 


## library Dependencies

Fcidecomp build dependencies:  charls-devel, zlib-devel, and hdf5-devel. 

For the merely purpose of building fcidecomp and for simplicity sake, these packages are also built and installed just for fcidecomp build. Follow the subsections below. 


##Build and Install dependencies from Source Code

Following descriptions work for both Linux and Windows, noting following:

	-At the time of this build, used versions were charls-2.4.2; zlib-1.3.1; hdf5-1.14.6 
      -Windows-1x 64-bits cmake uses by default: -G "Visual Studio 17 2022" -A x64
      -in Windows use Developer Powershell to run cmake
      -in Windows use windows pathnames, e.g. "C:\Users\local" 

### Charls

Get charls source code zip or tar.gz:   
		in brower, https://github.com/team-charls/charls/releases  
		or, wget https://github.com/team-charls/charls/archive/refs/tags/v2.4.2.zip -O charls-v2.4.2.z


    Alternatively: git clone  -b 2.4.2 https://github.com/team-charls/charls.git

    
Unpack or clone the source code under a local directory: e.g.  $HOME/charls-2.4.2

Create build directory: 
	mkdir $HOME/charls-2.4.2/build
	cd    $HOME/charls-2.4.2/build

Build and Install static CharLS:
	 cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="$HOME/.local/charls"
	cmake --build . --config=Release
	cmake --install . 


### zlib

Get zlib source code zip or tar.gz:
		in brower: https://zlib.net/  (1.3.1):   

Unpack or clone the source code under a local directory: e.g.  $HOME/zlib-1.3.1

Create build directory: 
	mkdir $HOME/zlib-1.3.1/build
	cd    $HOME/zlib-1.3.1/build

Build and Install:
	cmake -S .. -B .  -DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="$HOME/.local/zlib"
	cmake --build . --config=Release
	cmake --install . --config=Release



### hdf5

Get source code zip or tar.gz:
		in brower: https://github.com/HDFGroup/hdf5/tree/hdf5_1_14_6  https://github.com/HDFGroup/hdf5/tree/hdf5_1_14_6

Unpack or clone the source code under a local directory: e.g.  $HOME/hdf5-1.14.6

Create build directory: 
	mkdir hdf5-1.14.6/build
	cd    hdf5-1.14.6/build

Build and Install:

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

	cmake --build . --config=Release
	cmake --install . --config=Release



## Build and install ``fcidecomp``

``fcidecomp`` can be built -once the dependencies are installed: charls-devel, zlib-devel, and hdf5-devel are installed.

 Get source code zip or tar.gz: https://gitlab.eumetsat.int/open-source/fcidecomp/

  	   tar xzvf fcidecomp-$FCIDECOMP_TAG.tar.gz

     Alternatively, git clone -b <fcidecomp_tag> https://gitlab.eumetsat.int/open-source/fcidecomp/

Create build directory:
    mkdir fcidecomp-<fcidecomp_tag>/src/fcidecomp/build
    cd    fcidecomp-<fcidecomp_tag>/src/fcidecomp/build

Build and Install:

  cmake -S .. -B . 
     -DCMAKE_POSITION_INDEPENDENT_CODE=ON
     -DCMAKE_BUILD_TYPE=Release   
     -DCMAKE_INSTALL_PREFIX="$HOME/.local/fcidecomp" 
     -DBUILD_SHARED_LIBS=OFF   
     -DCHARLS_ROOT="$HOME/.local/charls"
     -DZLIB_ROOT="$HOME/.local/zlib"
     -DHDF5_ROOT="$HOME/.local/hdf5"

  cmake --build . --config=Release
  cmake --install .  --config=Release

Note: if any of charls, zlib and/or hdf5 are installed in default system paths and you want to use them, you don't need to specify those variables, cmake will find them. Otherwise specify their location. 

Finally, set the environment variable ``HDF5_PLUGIN_PATH`` to the install path of the compiled HDF5 plugin

 	Linux:
         export PATH=$PATH:<hdf5_installation_path>/bin
         export HDF5_PLUGIN_PATH=<hdf5_installation_path>/lib/plugin/
	 

	Windows:
         $env:PATH += "C:\Users\romeror\.local\hdf5\bin"
         $env:HDF5_PLUGIN_PATH = "C:\Users\romeror\.local\fcidecomp\bin"


