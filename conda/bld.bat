:: =============================================================
::
:: Copyright 2021-2023, European Organisation for the Exploitation of Meteorological Satellites (EUMETSAT)
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.
::
:: =============================================================

:: AUTHORS:
:: - B-Open Solutions srl

@echo ON
setlocal enabledelayedexpansion

set PATH_TO_DELIVERY=%cd%
set FCIDECOMP_BUILD_PATH=%PATH_TO_DELIVERY%\build
if not exist "%FCIDECOMP_BUILD_PATH%" mkdir "%FCIDECOMP_BUILD_PATH%"

set CHARLS_VERSION=2.4.2
set CHARLS_SRC=%FCIDECOMP_BUILD_PATH%\charls-%CHARLS_VERSION%

rem Build static CharLS from source and install to %LIBRARY_PREFIX%
curl -L -o %FCIDECOMP_BUILD_PATH%\charls-%CHARLS_VERSION%.tar.gz https://github.com/team-charls/charls/archive/refs/tags/%CHARLS_VERSION%.tar.gz
if errorlevel 1 exit 1
tar -xzf %FCIDECOMP_BUILD_PATH%\charls-%CHARLS_VERSION%.tar.gz -C %FCIDECOMP_BUILD_PATH%
if errorlevel 1 exit 1
cmake -S %CHARLS_SRC% -B %CHARLS_SRC%\build                              ^
    -DCMAKE_BUILD_TYPE="Release"                                         ^
    -DBUILD_SHARED_LIBS=OFF                                               ^
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON                                 ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%
if errorlevel 1 exit 1
cmake --build %CHARLS_SRC%\build --config Release
if errorlevel 1 exit 1
cmake --install %CHARLS_SRC%\build --config Release
if errorlevel 1 exit 1

rem Build FCIDECOMP with the unified CMake flow
cmake -S %PATH_TO_DELIVERY%\fcidecomp -B %FCIDECOMP_BUILD_PATH%           ^
    -DCMAKE_BUILD_TYPE="Release"                                         ^
    -DBUILD_SHARED_LIBS=OFF                                               ^
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON                                 ^
    -DCMAKE_PREFIX_PATH=%CONDA_PREFIX%;%LIBRARY_PREFIX%                   ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%                               ^
    -DCHARLS_ROOT=%LIBRARY_PREFIX%
if errorlevel 1 exit 1

cmake --build %FCIDECOMP_BUILD_PATH% --config Release
if errorlevel 1 exit 1

cmake --install %FCIDECOMP_BUILD_PATH% --config Release
if errorlevel 1 exit 1

cd %FCIDECOMP_BUILD_PATH%
call %PREFIX%\Scripts\pip install --no-deps --ignore-installed -vv %RECIPE_DIR%/../src/fcidecomp-python

if not exist %PREFIX%\etc\conda\activate.d mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\scripts\activate.bat %PREFIX%\etc\conda\activate.d\%PKG_NAME%_activate.bat
copy %RECIPE_DIR%\scripts\activate.ps1 %PREFIX%\etc\conda\activate.d\%PKG_NAME%_activate.ps1
copy %RECIPE_DIR%\scripts\activate.sh %PREFIX%\etc\conda\activate.d\%PKG_NAME%_activate.sh
if not exist %PREFIX%\etc\conda\deactivate.d mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\scripts\deactivate.bat %PREFIX%\etc\conda\deactivate.d\%PKG_NAME%_deactivate.bat
copy %RECIPE_DIR%\scripts\deactivate.ps1 %PREFIX%\etc\conda\deactivate.d\%PKG_NAME%_deactivate.ps1
copy %RECIPE_DIR%\scripts\deactivate.sh %PREFIX%\etc\conda\deactivate.d\%PKG_NAME%_deactivate.sh
