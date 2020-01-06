#!/usr/bin/env bash

msg() {
    echo -e "${TEXT_BOLD}"
    echo -e "/* $1 */"
    echo -e "${TEXT_RESET}"
}

export MAKE_JOBS="$(( $(nproc) * 6 / 5 ))"
export SDFUSE="/uboot/sd_fuse/sd_fusing.sh"
[ -z $USER_UID ] && USER_UID=1000
[ -z $USER_GID ] && USER_GID=1000

# Display environment variables
echo -e "Variables:
\\t- USER_UID=$USER_UID
\\t- USER_GID=$USER_GID
\\t- SBC=$SBC
\\t- MAKE_ARGS=${MAKE_ARGS,,}
\\t- AUTO_INSTALL=${AUTO_INSTALL,,}
\\t- BLOCK_DEVICE=${BLOCK_DEVICE,,}"

msg "Set environment variables for ${SBC,,}..."
if [ "${SBC,,}" = "xu4" ]; then
    export ARCH="arm"
    export CROSS_COMPILE="arm-linux-gnueabihf-"
    export PATH="/toolchains/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/:$PATH"
    export DEFCONFIG="odroid-xu4_defconfig"
elif [ "${SBC,,}" = "c1" ]; then
    export ARCH="arm"
    export CROSS_COMPILE="arm-linux-gnueabihf-"
    export PATH="/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux/bin:$PATH"
    export DEFCONFIG="odroidc_defconfig"
elif [ "${SBC,,}" = "c2" ]; then
    export ARCH="arm"
    export CROSS_COMPILE="aarch64-none-elf-"
    export PATH="/toolchains/gcc-linaro-aarch64-none-elf-4.9-2014.09_linux/bin/:$PATH"
    export DEFCONFIG="odroidc2_defconfig"
elif [ "${SBC,,}" = "n2" ]; then
    export ARCH="arm64"
    export CROSS_COMPILE="aarch64-none-elf-"
    export PATH="/toolchains/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin:/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux/bin:$PATH"
    export DEFCONFIG="odroidn2_defconfig"
else
    msg "You have to specify what Odroid SBC you will build a U-Boot."
    msg "Program will be terminated."
    exit
fi

if [ "$MAKE_ARGS" = "cleanbuild" ]; then
    msg "Clean up the workspace then build from the scratch..."
    make -j "$MAKE_JOBS" distclean
    make -j "$MAKE_JOBS" "$DEFCONFIG"
    make -j "$MAKE_JOBS"
elif [ "$MAKE_ARGS" = "clean" ]; then
    msg "Clean the workspace..."
    make -j "$MAKE_JOBS" clean
elif [ "$MAKE_ARGS" = "distclean" ]; then
    msg "Clean up the workspace to back to the initial state..."
    make -j "$MAKE_JOBS" distclean
elif [ "$MAKE_ARGS" = "defconfig" ]; then
    msg "Do make $DEFCONFIG..."
    make -j "$MAKE_JOBS" "$DEFCONFIG"
elif [ "$MAKE_ARGS" = "menuconfig" ]; then
    msg "Do make menuconfig..."
    make -j "$MAKE_JOBS" "menuconfig"
elif [ -z "$MAKE_ARGS" ]; then
    msg "Do make -j "$MAKE_JOBS"..."
    make -j "$MAKE_JOBS"
else
    msg "Do make -j "$MAKE_JOBS" $MAKE_ARGS..."
fi

if [ "$AUTO_INSTALL" = "true" ] && [ "$BLOCK_DEVICE" = *"/dev/sd"* ]; then
    msg "Install U-Boot to the selected block device "$BLOCK_DEVICE" automatically..."
    "$SDFUSE" "$BLOCK_DEVICE"
fi

msg "Copy the result files to the output directory. Check if you have given a output directory..."
[ -f "/uboot/u-boot.bin" ] && cp -arfv /uboot/u-boot.bin /output
cp -arfv /uboot/sd_fuse/* /output

chown -R "$USER_UID":"$USER_GID" /uboot
[ "$OUTPUT_DIR" = "true" ] && chown -R "$USER_UID":"$USER_GID" /output

sync
msg "All processes are done!"
