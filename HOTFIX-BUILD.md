# Conjuration Limit Fix1.4.1 guarded hotfix

Build: sh work/conjuration-limit-fix/build-linux.sh; optional COMMONLIB_WORKBENCH_CACHE uses our source-built clang-cl21.1.8 /MT library with SHA/compiler/CRT checks. Default clean source build is available but this revision was compiled using that checked cache. Upstream metadata1.0 and DLL name retained.

Only runtime1.7.104.0 is guarded/verified. Both original call bytes and callee IDs must match before either patch. 28-byte trampoline allocation fixed and commanded-data ABI corrected using actual executable evidence. See tasks/H3-conjuration-limit-fix.md and out/conjuration-limit-fix/evidence. Old SOURCE-UNVERIFIED checkpoints are superseded; no target beyond1.7.104 is implied.

Host guard-predicate test: g++ -std=c++20 tests/guard-predicate-host.cpp -o guard-test && ./guard-test. This tests the comparison predicate only, not game behaviour. No executable or AddressLibrary binary is shipped with source.
