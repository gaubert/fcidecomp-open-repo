#!/usr/bin/env python3
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
"""Generate the fcidecomp CycloneDX 1.5 software bill of materials.

The dependency manifest below must be kept in sync with the "Tools
versions" table in README.md, the CI workflows, the conda recipe and
the CMake FetchContent declarations.

Usage:
    python3 scripts/generate_sbom.py [--output sbom.cdx.json] [--timestamp YYYY-MM-DDTHH:MM:SSZ]
"""
import argparse
import json
import sys
from datetime import datetime, timezone

PROJECT_NAME = "fcidecomp"
PROJECT_VERSION = "2.1.2"
PROJECT_DESCRIPTION = (
    "EUMETSAT fcidecomp software: HDF5 filter plugin (H5ZJPEGLS) enabling "
    "decompression of MTG JPEG-LS netCDF files."
)

# (type, name, version, purl, license_spdx, url, description)
COMPONENTS = [
    ("library", "charls", "2.4.2", "pkg:github/team-charls/charls@2.4.2",
     "BSD-3-Clause", "https://github.com/team-charls/charls",
     "JPEG-LS codec library, built and linked statically (build-time dependency)"),
    ("library", "zlib", "1.3.1", "pkg:github/madler/zlib@1.3.1",
     "Zlib", "https://github.com/madler/zlib",
     "Compression library, fetched at build time via CMake FetchContent"),
    ("library", "hdf5", "1.14.0", "pkg:github/HDFGroup/hdf5@1.14.0",
     "BSD-3-Clause", "https://www.hdfgroup.org/solutions/hdf5/",
     "HDF5 library; versions 1.12.x to 1.14.x tested (build and runtime dependency)"),
    ("library", "libnetcdf", "4.8.1", "pkg:github/Unidata/netcdf-c@4.8.1",
     "MIT", "https://www.unidata.ucar.edu/software/netcdf/",
     "netCDF-C library (build and runtime dependency)"),
    ("library", "h5py", "3.6.0", "pkg:pypi/h5py@3.6.0",
     "BSD-3-Clause", "https://github.com/h5py/h5py",
     "Python HDF5 bindings (optional Python runtime dependency)"),
    ("library", "netCDF4", "1.6.2", "pkg:pypi/netCDF4@1.6.2",
     "MIT", "https://github.com/Unidata/netcdf4-python",
     "Python netCDF library (optional Python runtime dependency)"),
    ("application", "CPython", "3.12.0", None,
     "Python-2.0", "https://www.python.org",
     "Python interpreter; versions 3.9 to 3.12 tested (optional Python runtime dependency)"),
]


def build_bom(timestamp):
    components = []
    for ctype, name, version, purl, spdx, url, description in COMPONENTS:
        comp = {
            "type": ctype,
            "name": name,
            "version": version,
            "description": description,
            "licenses": [{"license": {"id": spdx}}],
        }
        if purl:
            comp["purl"] = purl
        components.append(comp)
    return {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "version": 1,
        "metadata": {
            "timestamp": timestamp,
            "tools": [{"name": "generate_sbom.py", "version": "1.0"}],
            "component": {
                "type": "application",
                "name": PROJECT_NAME,
                "version": PROJECT_VERSION,
                "description": PROJECT_DESCRIPTION,
            },
        },
        "components": components,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default="sbom.cdx.json")
    parser.add_argument("--timestamp", default=None,
                        help="ISO-8601 timestamp (default: current UTC time)")
    args = parser.parse_args()
    timestamp = args.timestamp or datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    bom = build_bom(timestamp)
    with open(args.output, "w") as f:
        json.dump(bom, f, indent=2)
        f.write("\n")
    print(f"Wrote {args.output} ({len(bom['components'])} components)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
