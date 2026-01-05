# =============================================================
#
# Copyright 2021-2023, European Organisation for the Exploitation of Meteorological Satellites (EUMETSAT)
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
# - B-Open Solutions srl

# Code inspired by:
# - https://github.com/conda-forge/charls-feedstock/blob/master/recipe/build.sh
# - https://github.com/mraspaud/fcidecomp-conda-recipe/blob/master/build.sh

#set -ex

 $PYTHON -m pip install $RECIPE_DIR/../src/fcidecomp-python --no-deps --ignore-installed -vv


PATH_TO_DELIVERY=$(pwd)
FCIDECOMP_BUILD_PATH=${PATH_TO_DELIVERY}/build
mkdir -p ${FCIDECOMP_BUILD_PATH}
cd ${FCIDECOMP_BUILD_PATH}

# Build static CharLS from source and install to $PREFIX
CHARLS_VERSION=2.4.2
curl -L -o charls-${CHARLS_VERSION}.tar.gz https://github.com/team-charls/charls/archive/refs/tags/${CHARLS_VERSION}.tar.gz
tar -xzf charls-${CHARLS_VERSION}.tar.gz
cmake -S charls-${CHARLS_VERSION} -B charls-${CHARLS_VERSION}/build       \
    -DCMAKE_BUILD_TYPE=Release                                            \
    -DBUILD_SHARED_LIBS=OFF                                                \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON                                  \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}"
cmake --build charls-${CHARLS_VERSION}/build --config Release
cmake --install charls-${CHARLS_VERSION}/build --config Release

# Build FCIDECOMP with the unified CMake flow
FCIDECOMP_SRC=${PATH_TO_DELIVERY}/fcidecomp
cmake -S "${FCIDECOMP_SRC}" -B "${FCIDECOMP_BUILD_PATH}"                  \
    -DCMAKE_BUILD_TYPE=Release                                            \
    -DBUILD_SHARED_LIBS=OFF                                               \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON                                  \
    -DCMAKE_PREFIX_PATH="${PREFIX}"                                       \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}"                                    \
    -DCHARLS_ROOT="${PREFIX}"
cmake --build "${FCIDECOMP_BUILD_PATH}" --config Release
cmake --install "${FCIDECOMP_BUILD_PATH}" --config Release


mkdir -p "${PREFIX}/etc/conda/activate.d"
cp "${RECIPE_DIR}/scripts/activate.sh" "${PREFIX}/etc/conda/activate.d/${PKG_NAME}_activate.sh"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp "${RECIPE_DIR}/scripts/deactivate.sh" "${PREFIX}/etc/conda/deactivate.d/${PKG_NAME}_deactivate.sh"
