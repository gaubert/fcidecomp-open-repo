@echo off
setlocal enabledelayedexpansion

set "NC_DUMP=ncdump"
set "H5_DUMP=h5dump"
set "PLUGIN_BASENAME=H5Zjpegls.dll"
set "SAMPLE_FILE_NAME=W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-HRFI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20260507092518_IDPFI_OPE_20260507092052_20260507092132_N_JLS_O_0057_0007.nc"
set "DATASET_PATH=/data/vis_06_hr/measured/effective_radiance"

rem Get script path
set "SCRIPT_PATH=%~dp0"
set "DATA_DIR=%SCRIPT_PATH%data"
set "NC_FILE=%DATA_DIR%\%SAMPLE_FILE_NAME%"
set "OUTPUT_FULL=%DATA_DIR%\sample_full.txt"
set "OUTPUT_FILE=%DATA_DIR%\sample.txt"
set "SAMPLE_REF=%DATA_DIR%\sample_ref.txt"

rem Check ncdump availability
where %NC_DUMP% >nul 2>&1
if errorlevel 1 (
  echo Error: %NC_DUMP% cannot be run. Check your installation of netCDF and set ncdump utility in your PATH environment variable.
  goto :fail
)
where %H5_DUMP% >nul 2>&1
if errorlevel 1 (
  echo Error: %H5_DUMP% cannot be run. Check your installation of HDF5 tools and set h5dump utility in your PATH environment variable.
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

echo %NC_DUMP%: Reading header from file: %NC_FILE% ...
%NC_DUMP% -h %NC_FILE% >nul
if errorlevel 1 (
  echo %NC_DUMP%: Error reading file header: %NC_FILE%
  goto :fail
)

echo %H5_DUMP%: Reading dataset subset from file: %NC_FILE% ...
%H5_DUMP% -d %DATASET_PATH% -s "250,10000" -c "3,8" %NC_FILE% > "%OUTPUT_FULL%"
if errorlevel 1 (
  echo %H5_DUMP%: Error reading dataset subset from file: %NC_FILE%
  goto :fail
)

> "%OUTPUT_FILE%" (
  for /f "usebackq tokens=* delims= " %%L in (`findstr /C:"(250,10000):" /C:"(251,10000):" /C:"(252,10000):" "%OUTPUT_FULL%"`) do (
    echo %%L
  )
)
if errorlevel 1 (
  echo Failed to extract the expected dataset lines from %OUTPUT_FULL%
  goto :fail
)

echo Comparing the output files to the reference files:
echo   Comparing %OUTPUT_FILE%
echo          to %SAMPLE_REF%
fc "%OUTPUT_FILE%" "%SAMPLE_REF%" >nul
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
