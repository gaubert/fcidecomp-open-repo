@echo off
setlocal enabledelayedexpansion

set "NC_DUMP=ncdump"
set "PLUGIN_BASENAME=H5Zjpegls.dll"

rem Get script path
set "SCRIPT_PATH=%~dp0"
set "DATA_DIR=%SCRIPT_PATH%data"
set "NC_FILE=%DATA_DIR%\sample.nc"
set "OUTPUT_FILE=%DATA_DIR%\sample.txt"
set "SAMPLE_REF=%DATA_DIR%\sample_ref.txt"

rem Check ncdump availability
where %NC_DUMP% >nul 2>&1
if errorlevel 1 (
  echo Error: %NC_DUMP% cannot be run. Check your installation of netCDF and set ncdump utility in your PATH environment variable.
  goto :fail
)

echo Environment:
echo   HDF5_PLUGIN_PATH: %HDF5_PLUGIN_PATH%
for /f "usebackq delims=" %%p in (`where %NC_DUMP%`) do (
  echo   %NC_DUMP% path: %%p
  goto :after_ncdump_path
)
:after_ncdump_path

rem Locate plugin in HDF5_PLUGIN_PATH
if "%HDF5_PLUGIN_PATH%"=="" (
  echo Plugin: HDF5_PLUGIN_PATH is not set; plugin discovery may fail.
  goto :fail
)

set "PLUGIN_FOUND="
for %%p in ("%HDF5_PLUGIN_PATH:;=" "%") do (
  if exist "%%~p\%PLUGIN_BASENAME%" (
    echo Plugin: using %%~p\%PLUGIN_BASENAME%
    set "PLUGIN_FOUND=1"
    goto :after_plugin_search
  )
)

:after_plugin_search
if not defined PLUGIN_FOUND (
  echo Plugin: %PLUGIN_BASENAME% not found in HDF5_PLUGIN_PATH
  goto :fail
)

echo %NC_DUMP%: Reading file: %NC_FILE% ...
%NC_DUMP% %NC_FILE% > "%OUTPUT_FILE%"
if errorlevel 1 (
  echo %NC_DUMP%: Error reading file: %NC_FILE%
  goto :fail
)

echo Comparing the output files to the reference files:
echo   Comparing %OUTPUT_FILE%
echo          to %SAMPLE_REF%
fc /b "%OUTPUT_FILE%" "%SAMPLE_REF%" >nul
if errorlevel 1 (
  echo Error: the output file does not match the reference file!
  echo %OUTPUT_FILE%
  echo %SAMPLE_REF%
  goto :fail
)

echo *** SUCCESS ! ***
exit /b 0

:fail
echo *** FAIL: Post-installation test failed! ***
exit /b 1
