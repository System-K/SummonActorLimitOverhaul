#include <array>
#include <cstdint>
#include <cstring>
#include <cassert>
#include <iostream>
    static bool IsVerifiedCall(std::uintptr_t site, const std::array<std::uint8_t, 5>& expected, std::uintptr_t callee) {
        if (std::memcmp(reinterpret_cast<const void*>(site), expected.data(), expected.size()) != 0) {
            return false;
        }
        std::int32_t displacement = 0;
        std::memcpy(&displacement, reinterpret_cast<const void*>(site + 1), sizeof(displacement));
        return site + 5 + static_cast<std::intptr_t>(displacement) == callee;
    }

int main() {
 std::array<std::uint8_t,5> bytes{0xE8,0x60,0x35,0,0};
 const auto expected=bytes; auto site=reinterpret_cast<std::uintptr_t>(bytes.data());
 auto callee=site+5+0x3560;
 assert(IsVerifiedCall(site,expected,callee));
 assert(!IsVerifiedCall(site,expected,callee+1));
 bytes[1]^=1; assert(!IsVerifiedCall(site,expected,callee));
 bytes=expected; bytes[0]=0xE9; assert(!IsVerifiedCall(site,expected,callee));
 std::cout << "4 host guard-predicate cases passed; not a game/runtime test\n";
}
