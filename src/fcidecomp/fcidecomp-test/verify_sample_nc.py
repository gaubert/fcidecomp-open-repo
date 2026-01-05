#!/usr/bin/env python3
import os
import sys

from netCDF4 import Dataset


def main() -> int:
    default_path = os.path.join(
        "src",
        "fcidecomp",
        "fcidecomp-test",
        "data",
        "sample.nc",
    )
    nc_path = sys.argv[1] if len(sys.argv) > 1 else default_path

    if not os.path.exists(nc_path):
        print(f"Error: file not found: {nc_path}")
        return 1

    with Dataset(nc_path, "r") as ds:
        if "effective_radiance" not in ds.variables:
            print("Error: variable 'effective_radiance' not found")
            return 1
        data = ds.variables["effective_radiance"][:].ravel()

    if data.size < 100:
        print(f"Error: expected at least 100 values, got {data.size}")
        return 1

    expected = list(range(100))
    actual = [int(v) for v in data[:100]]
    for idx, (got, exp) in enumerate(zip(actual, expected)):
        if got != exp:
            print(f"Mismatch at index {idx}: expected {exp}, got {got}")
            return 1

    print("OK: first 100 values match expected sequence 0..99")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
