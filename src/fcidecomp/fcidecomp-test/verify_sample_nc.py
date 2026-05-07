#!/usr/bin/env python3
import os
import sys

from netCDF4 import Dataset

SAMPLE_FILE_NAME = (
    "W_XX-EUMETSAT-Darmstadt,IMG+SAT,MTI1+FCI-1C-RRAD-HRFI-FD--CHK-BODY--DIS-NC4E_C_EUMT_20260507092518_"
    "IDPFI_OPE_20260507092052_20260507092132_N_JLS_O_0057_0007.nc"
)
EXPECTED = [
    [319, 324, 325, 323, 324, 324, 320, 322],
    [321, 323, 322, 322, 322, 319, 319, 317],
    [322, 320, 318, 318, 316, 316, 316, 317],
]


def main() -> int:
    default_path = os.path.join(
        "src",
        "fcidecomp",
        "fcidecomp-test",
        "data",
        SAMPLE_FILE_NAME,
    )
    nc_path = sys.argv[1] if len(sys.argv) > 1 else default_path

    if not os.path.exists(nc_path):
        print(f"Error: file not found: {nc_path}")
        return 1

    with Dataset(nc_path, "r") as ds:
        try:
            measured = ds.groups["data"].groups["vis_06_hr"].groups["measured"]
        except KeyError as exc:
            print(f"Error: expected group hierarchy not found: {exc}")
            return 1

        if "effective_radiance" not in measured.variables:
            print("Error: variable 'effective_radiance' not found in data/vis_06_hr/measured")
            return 1

        data = measured.variables["effective_radiance"][250:253, 10000:10008]

    if data.shape != (3, 8):
        print(f"Error: expected a 3x8 subset, got shape {data.shape}")
        return 1

    for row_idx, (actual_row, expected_row) in enumerate(zip(data, EXPECTED)):
        actual_values = [int(value) for value in actual_row]
        if actual_values != expected_row:
            print(f"Mismatch in row {row_idx}: expected {expected_row}, got {actual_values}")
            return 1

    print("OK: effective_radiance subset matches expected reference values")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
