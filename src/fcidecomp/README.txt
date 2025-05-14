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




Testing the build
-----------------
To test please do with -DCHARLS_ROOT pointing to charls static library. It should be easily possible as well to automatically fetch CHARLS and build it in the process and then there is no need to have this external dependency in the build

$> mkdir build ; cd build

#You have to indicate where is charls and where to install
$> rm -Rf CMakeFiles; rm -f CMakeCache.txt; cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCHARLS_ROOT=/home/gmv/Dev/fcidecomp_Fabrizio/libs/charls -DCMAKE_INSTALL_PREFIX=/home/gmv/Dev/fcidecomp_Fabrizio/libs/fcidecomp
$> make -j8
$> make install
