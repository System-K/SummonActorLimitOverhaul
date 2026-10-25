#!/bin/sh
# SKSE-Hotfixes: Windows x64 cross-build for Skyrim 1.7.104 and Address Library v5.
set -eu
T="${SKSE_TOOLCHAIN_ROOT:-/mnt/h/dev/modding/toolchain}"
export PATH="$T/bin:$PATH" VCPKG_ROOT="$T/vcpkg" COMMONLIB_SSE_FOLDER="$T/commonlibsse-ng"
# SKSE-Hotfixes: reject a different CommonLib checkout instead of silently changing the target ABI.
EXPECTED_CLIB=dbb86c2523fae0cc70de074f3e2d1a6b657758dc
[ "$(git -C "$COMMONLIB_SSE_FOLDER" rev-parse HEAD)" = "$EXPECTED_CLIB" ] || {
  echo "Wrong CommonLib revision; expected $EXPECTED_CLIB" >&2; exit 1;
}
cmake -S "$(dirname "$0")" -B "$(dirname "$0")/build/linux" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM="$(command -v ninja)" \
  -DCMAKE_TOOLCHAIN_FILE="$T/vcpkg/scripts/buildsystems/vcpkg.cmake" \
  -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE="$T/clang-cl-xwin.cmake" \
  -DVCPKG_TARGET_TRIPLET=x64-windows-static-xwin -DVCPKG_OVERLAY_TRIPLETS="$T/triplets" \
  -DVCPKG_OVERLAY_PORTS="$T/ports" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded \
  -DXWIN_EXTRA_CXX_FLAGS="/permissive- /Zc:preprocessor -DNOMINMAX -DUNICODE -D_UNICODE -D_WIN32_WINNT=0x0A00" \
  -DCOMMONLIB_WORKBENCH_CACHE="${COMMONLIB_WORKBENCH_CACHE:-}" \
  -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF -DBUILD_TESTS=OFF
cmake --build "$(dirname "$0")/build/linux" -j "${BUILD_JOBS:-2}"
