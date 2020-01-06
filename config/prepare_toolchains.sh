#!/usr/bin/env bash

# Toolchain download links
TC_URLS=(
    # XU4 (v2017.05)
    "https://releases.linaro.org/archive/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz"
    # C1 (v2011.03)
    "https://releases.linaro.org/archive/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz"
    # C2 (v2015.01)
    "https://releases.linaro.org/archive/14.09/components/toolchain/binaries/gcc-linaro-aarch64-none-elf-4.9-2014.09_linux.tar.xz"
    # N2 (v2015.01)
    "https://releases.linaro.org/archive/13.11/components/toolchain/binaries/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.xz"
    "https://releases.linaro.org/archive/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz"
)

# Extract to /toolchains directory
for URL in "${TC_URLS[@]}"; do
    FILE="$(echo "$URL" | sed "s/.*\///")"

    wget -nv "$URL" -P /toolchains

    case "$URL" in
        *"tar.gz")
            tar xfz /toolchains/"$FILE" -C /toolchains
            ;;
        *"tar.xz")
            tar xfJ /toolchains/"$FILE" -C /toolchains
            ;;
        *"tar.bz2")
            tar xfj /toolchains/"$FILE" -C /toolchains
            ;;
    esac
done
