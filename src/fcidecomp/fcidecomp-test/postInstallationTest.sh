#!/bin/bash
# =============================================================
#
# Copyright 2015-2023, European Organisation for the Exploitation of Meteorological Satellites (EUMETSAT)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# =============================================================

# AUTHORS:
# - THALES Services
# - B-Open Solutions srl

set -o nounset
set -o errexit


# Perform FCI decompression software post-installation tests.
#
# Usage:
# 
# $ ./postInstallationTest.sh
#   

NC_DUMP="ncdump"
H5_DUMP="h5dump"
PLUGIN_BASENAMES=("libH5Zjpegls" "H5Zjpegls")
SAMPLE_FILE_NAME="W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-HRFI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20260507092518_IDPFI_OPE_20260507092052_20260507092132_N_JLS_O_0057_0007.nc"
DATASET_PATH="/data/vis_06_hr/measured/effective_radiance"
DATASET_START="250,10000"
DATASET_COUNT="3,8"

# Get the path to that script
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Define the data directory
DATA_DIR=${SCRIPT_PATH}/data

# Define the end user simulator input
NC_FILE=${DATA_DIR}/${SAMPLE_FILE_NAME}

# Define the ncdump outputs
NC_DUMP_OUT_DIR=${DATA_DIR}
OUTPUT_FILE=${DATA_DIR}/sample.txt

# Define the reference data files
SAMPLE_REF=${DATA_DIR}/sample_ref.txt

# ====================================================================
# Print the usage
# ====================================================================
function usage {
    echo "Usage: $0" 1>&2
    exit 1
}

# ====================================================================
# Print the help
# ====================================================================
function help { 
    echo "Check that the installation of the FCIDECOMP software is correct."
    echo ""
    echo "This script uses ncdump utility to read the data inside the"
    echo " compressed netCDF file and checks that the data are correct"
    echo " by comparing the extracted data with the reference data."
    echo ""
    usage $@
}

# ====================================================================
# Return 0 if the command exist
# ====================================================================
function command_exists () {
    type "$1" &> /dev/null ;
}

# ====================================================================
# Convert Windows-style paths to shell-readable paths when possible
# ====================================================================
function normalize_shell_path {
    local input_path="${1:-}"

    if [[ -z "${input_path}" ]]; then
        return 0
    fi

    if command_exists cygpath; then
        if [[ "${input_path}" == *\\* ]] || [[ "${input_path}" =~ ^[A-Za-z]: ]]; then
            cygpath -u "${input_path}" 2>/dev/null || printf '%s\n' "${input_path}"
            return 0
        fi
    fi

    printf '%s\n' "${input_path}"
}

# ====================================================================
# Exit failure function
# ====================================================================
function exit_failure {
    echo "*** FAIL: Post-installation test failed! ***"
    exit 1;
}

# ====================================================================
# Print environment details used by the test
# ====================================================================
function print_environment {
    local ncdump_path
    local h5dump_path
    ncdump_path=$(command -v "$NC_DUMP" || true)
    h5dump_path=$(command -v "$H5_DUMP" || true)
    echo "Environment:"
    echo "  HDF5_PLUGIN_PATH: ${HDF5_PLUGIN_PATH:-<not set>}"
    echo "  ${NC_DUMP} path: ${ncdump_path:-<not found>}"
    echo "  ${H5_DUMP} path: ${h5dump_path:-<not found>}"
    if [[ -n "${ncdump_path}" ]]; then
        "${NC_DUMP}" --version 2>/dev/null || true
    fi
}

# ====================================================================
# Report the plugin that will be used (if discoverable)
# ====================================================================
function print_plugin_info {
    local plugin_found=0
    local plugin_match
    local plugin_dir
    local plugin_base
    local path_separator=':'
    if [[ -z "${HDF5_PLUGIN_PATH:-}" ]]; then
        echo "Plugin: HDF5_PLUGIN_PATH is not set; plugin discovery may fail."
        return 0
    fi

    if [[ "${HDF5_PLUGIN_PATH}" == *";"* ]]; then
        path_separator=';'
    elif [[ "${HDF5_PLUGIN_PATH}" =~ ^[A-Za-z]:[\\/].* ]]; then
        path_separator=$'\n'
    fi

    while IFS= read -r plugin_dir; do
        [[ -z "${plugin_dir}" ]] && continue
        local shell_plugin_dir
        shell_plugin_dir=$(normalize_shell_path "${plugin_dir}")
        if [[ ! -d "${shell_plugin_dir}" ]]; then
            echo "Plugin: directory not found: ${plugin_dir}"
            continue
        fi
        for plugin_base in "${PLUGIN_BASENAMES[@]}"; do
            plugin_match=$(find "${shell_plugin_dir}" -maxdepth 1 -type f -name "${plugin_base}.*" 2>/dev/null | head -n 1 || true)
            if [[ -n "${plugin_match}" ]]; then
                echo "Plugin: using ${plugin_match}"
                plugin_found=1
                break
            fi
        done
        [[ ${plugin_found} -eq 1 ]] && break
    done < <(printf '%s\n' "${HDF5_PLUGIN_PATH}" | tr "${path_separator}" '\n')

    if [[ ${plugin_found} -eq 0 ]]; then
        echo "Plugin: no match found; contents of HDF5_PLUGIN_PATH:"
        printf '%s\n' "${HDF5_PLUGIN_PATH}" | tr "${path_separator}" '\n' | while IFS= read -r plugin_dir; do
            [[ -z "${plugin_dir}" ]] && continue
            local shell_plugin_dir
            shell_plugin_dir=$(normalize_shell_path "${plugin_dir}")
            echo "  ${plugin_dir}"
            ls -la "${shell_plugin_dir}" 2>/dev/null || true
        done
        echo "Plugin: no ${PLUGIN_BASENAMES[*]}.* found in HDF5_PLUGIN_PATH"
        exit_failure
    fi
}

# ====================================================================
# Parse the input arguments
# ====================================================================
function parse_inputs {

    # check the input number of arguments
    # otherwise print the usage
    if [[ $# -gt 1 ]]; then
	usage
	return 0
    fi

    if [[ $# -ge 1 ]]; then
        # check the first argument
	case ${1:-} in
	    -h|--help)
		help
		;;
	    *)  # default
		usage
		;;
	esac
    fi   
}

# ====================================================================
# Main
# ====================================================================
function main {
    # Parse the input command line
    parse_inputs $@

    # Check that required tools exist
    ! command_exists "$NC_DUMP" && { echo "Error: $NC_DUMP cannot be run. Check your installation of netCDF and set ncdump utility in your PATH environment variable." ; exit_failure ; }
    ! command_exists "$H5_DUMP" && { echo "Error: $H5_DUMP cannot be run. Check your installation of HDF5 tools and set h5dump utility in your PATH environment variable." ; exit_failure ; }
    print_environment
    print_plugin_info

    echo "$NC_DUMP: Reading header from file: $NC_FILE ..."
    "${NC_DUMP}" -h "$NC_FILE" > /dev/null || { echo "${NC_DUMP}: Error reading file header: $NC_FILE" ; exit_failure ; }

    echo "$H5_DUMP: Reading dataset subset from file: $NC_FILE ..."
    "${H5_DUMP}" -d "${DATASET_PATH}" -s "${DATASET_START}" -c "${DATASET_COUNT}" "$NC_FILE" \
        | sed -n -E 's/^ *\((25[0-2]),10000\): /\(\1,10000\): /p' > "$OUTPUT_FILE" \
        || { echo "${H5_DUMP}: Error reading dataset subset from file: $NC_FILE" ; exit_failure ; }

    echo "Comparing the output files to the reference files:"
    echo "  Comparing $OUTPUT_FILE"
    echo "         to $SAMPLE_REF"
    diff -q "$OUTPUT_FILE" "$SAMPLE_REF" || {
	echo "Error: the output file does not match the reference file!";
	echo "$OUTPUT_FILE"
	echo "$SAMPLE_REF"
	exit_failure ; }
	
    echo "*** SUCCESS ! ***"
    return 0
}

# Launch the main function
main $@
