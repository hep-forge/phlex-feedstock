#!/bin/bash
set -eo pipefail

cmake ${CMAKE_ARGS} -S "${SRC_DIR}" -B build --preset default \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_CXX_STANDARD="$(root-config --cxxstandard)" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_TESTING=OFF \
    -DENABLE_CLANG_TIDY=OFF \
    -DFORM_USE_RNTUPLE_STORAGE=ON
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build

# PHLEX_PLUGIN_PATH points at the plugin directory while the env is active.
for CHANGE in activate deactivate; do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    for EXT in sh csh fish; do
        cp "${RECIPE_DIR}/${CHANGE}.${EXT}" \
           "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.${EXT}"
    done
done
