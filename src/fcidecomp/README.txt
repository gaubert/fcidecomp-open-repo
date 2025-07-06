Below is what is needed to build the hdf5 fcidecomp plugin with the other library as static libraries.

The following files have been modified:

On branch guillaume-cmake-build-from-2.1.2
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   ../CMakeLists.txt
        new file:   ../README.txt
        new file:   ../cmake/modules/FetchCharLS.cmake

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ../../../.gitignore
        modified:   ../cmake/modules/FindCHARLS.cmake
        modified:   ../fcicomp-H5Zjpegls/CMakeLists.txt
        modified:   ../fcicomp-jpegls/CMakeLists.txt

Prerequisite: Build CHARLS statically
-------------------------------------
CHARLS needs to be built with the following options:
cmake -S . -B build \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/your/target/install/path

cmake --build build --target install

CMAKE_POSITION_INDEPENDENT_CODE to make the code loadable in a shared lib
BUILD_SHARED_LIBS_OFF to only generate the static lib


Testing the build
-----------------
To test please do with -DCHARLS_ROOT pointing to charls static library. It should be easily possible as well to automatically fetch CHARLS and build it in the process and then there is no need to have this external dependency in the build
export CHARLS_ROOT=/home/gmv/Dev/fcidecomp_Fabrizio/libs/charls

$> mkdir build ; cd build

#You have to indicate where is charls and where to install
$> rm -Rf CMakeFiles; rm -f CMakeCache.txt; cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCHARLS_ROOT=/home/gmv/Dev/fcidecomp_Fabrizio/libs/charls -DCMAKE_INSTALL_PREFIX=/home/gmv/Dev/fcidecomp_Fabrizio/libs/fcidecomp -DHDF5_ROOT=/home/gmv/Dev/fcidecomp_fromJoaquin/local/fcicomp_cots/hdf5
$> make -j8
$> make install

To Test do the following
------------------------
$> export HDF5_ROOT=/home/gmv/Dev/fcidecomp_fromJoaquin/local/fcicomp_cots/hdf5
$> export HDF5_PLUGIN_PATH=/home/gmv/Dev/fcidecomp_Fabrizio/libs/fcidecomp/hdf5/lib/plugin
$> export NETCDF_HOME=/home/gmv/Dev/fcidecomp_fromJoaquin/local/fcicomp_cots/netcdf
$> /home/gmv/Dev/fcidecomp_fromJoaquin/local/fcicomp_cots/netcdf/bin/nccopy  -F none /home/gmv/RC0050/FDHSI/W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-FDHSI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20240814081929_IDPFI_OPE_20240814081643_20240814081737_N_JLS_C_0050_0029.nc a.nc
$> 

No errors and no messages and a.nc is produced (-F none means no filters so uncompressed)

On Windows I could prepare everything with this:
  cmake .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCHARLS_ROOT="C:/Users/User/Dev-Guillaume/libs/charls" -DHDF5_ROOT="C:/Users/User/Dev-Guillaume/libs/hdf5" -DHDF5_INCLUDE_DIRS="C:/Users/User/Dev-Guillaume/libs/hdf5/include" -DHDF5_LIBRARIES="C:/Users/User/Dev-Guillaume/libs/hdf5/lib/hdf5.lib;C:/Users/User/Dev-Guillaume/libs/hdf5/lib/hdf5_cpp.lib" -DCMAKE_TOOLCHAIN_FILE="C:\Users\User\Dev-Guillaume\vcpkg\scripts\buildsystems\vcpkg.cmake" -DCMAKE_INSTALL_PREFIX="C:\Users\User\Dev-Guillaume\libs\Built-H5ZPlugin"
 
Installing Visual Community Studio, Cmake Tools inside and then compile charls and installing hdf5 and zlib with vcpkg

  cmake --build . --config Release
