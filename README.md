# docker-odroid-uboot-builder

![](https://img.shields.io/docker/automated/awesometic/odroid-uboot-builder)
![](https://img.shields.io/docker/build/awesometic/odroid-uboot-builder)
![](https://img.shields.io/microbadger/image-size/awesometic/odroid-uboot-builder)
![](https://img.shields.io/microbadger/layers/awesometic/odroid-uboot-builder)
![](https://img.shields.io/docker/pulls/awesometic/odroid-uboot-builder)
![](https://img.shields.io/docker/stars/awesometic/odroid-uboot-builder)

## What is this

This image is written for easy compile on development of **Odroid Linux U-Boot**.

This has each toolchain of the Odroid boards in advance, respectively. So you can compile with only **download Odroid U-Boot source code** and **pulling/running this image**.

## Is this run on macOS or Windows

Unfortunately, **partly not**.

This image runs on Ubuntu Linux based, which means that it runs on Linux Kernel. In macOS or Windows, their Docker will run this image on Linux VM due to the absence of the native Linux kernel on them.

So that the performance is tooooo slower than the native Linux machine does. In my case, on macOS 10.14 with E3-1230v3 processor, it takes more than 2 hours for compiling XU4 kernel.

For further information, please refer to [References](#References) section of this documents.

### WSL 2 (Windows Subsystem for Linux)

However, if you use Windows 20h1 or higher, you can build as fast as on the Linux system. In my experience, that difference is only a few minutes, probably it can be seconds for the powerful system.

You can refer to this link to know about [Docker WSL2 backend](https://docs.docker.com/docker-for-windows/wsl-tech-preview/).

## How to use

The basic usage is,

```bash
docker run -it --rm \
-v {U-Boot source path}:/uboot \
-v {Path to receive output U-Boot binaries from the image}:/output \
-e USER_UID={ UID to correct ownership, set 1000 by default } \
-e USER_GID={ GID to correct ownership, set 1000 by default } \
-e SBC={ The name of your SBC without the prefix word Odroid } \
-e BLOCK_DEVICE={ A device file path of the boot media that is to be passed } \
-e MAKE_ARGS={ make arguments you about to use } \
-e AUTO_INSTALL={ Install automatically to the boot media after complete building U-Boot } \
--device /dev/{ A block device to pass to the container } \
awesometic/odroid-uboot-builder
```

Looks quite complicate. The examples in the below.

* Just check build time

```bash
docker run -it --rm \
-v $(pwd):/uboot \
-e USER_UID=$UID \
-e USER_GID=$GID \
-e SBC=n2 \
-e MAKE_ARGS=cleanbuild \
awesometic/odroid-uboot-builder
```

* Save the built U-Boot binary to the shared folder

```bash
docker run -it --rm \
-v $(pwd):/uboot \
-v ~/uboot-outputs:/output \
-e USER_UID=$UID \
-e USER_GID=$GID \
-e SBC=n2 \
-e MAKE_ARGS=cleanbuild \
awesometic/odroid-uboot-builder
```

* Install automatically to your boot media

```bash
docker run -it --rm \
-v $(pwd):/uboot \
-e USER_UID=$UID \
-e USER_GID=$GID \
-e SBC=n2 \
-e BLOCK_DEVICE=/dev/sda \
-e MAKE_ARGS=cleanbuild \
-e AUTO_INSTALL=true \
--device /dev/sda \
awesometic/odroid-uboot-builder
```

### Choose the SBC

You have to put your Odroid device name as a value of **SBC** environment variable. Current supported list with board and its supported U-Boot versions is here.

* **XU4**: v2017.05
* **C1**: v2011.03
* **C2**: v2015.01
* **N2**: v2015.01

Operation confirmed on **XU4, C1, C2, N2**.

### Parameters for make command

You can put your parameters for the make command as a value of **MAKE_ARGS** environment variable. Here are the confirmed operations.

* **defconfig** for `make odroid$SBC_defconfig` repectively
* **menuconfig** for `make menuconfig`
* **clean** for `make clean`
* **distclean** for `make distclean`
* **cleanbuild** for `make distclean; make odroid$SBC_defconfig; make`
* **{no args}** for `make`

### Install automatically to your boot media

If you want to **install the U-Boot image to your boot media automatically**, make sure that your boot media mounted in advance to pass its partitions to container as the volumes. Then give the environment variable **AUTO_INSTALL=true**. In most of the Linux DISTROs, after inserting the boot media then that will be mounted to under **/media/$USER** directory.

### No Daemon mode

Do not run this image as a daemon. Promptly to be terminated because it doesn't have any jobs to do.

## References

### Hardkernel

* [Official Websites](https://www.hardkernel.com)
* [Wiki](https://wiki.odroid.com)
* [Forum](https://forum.odroid.com)

### General information

* [Documents of "docker run"](https://docs.docker.com/engine/reference/commandline/run/)
* [EXT4 on macOS](https://apple.stackexchange.com/questions/140536/how-do-i-mount-ext4-using-os-x-fuse)
* [Why performance is slow on macOS/Windows](https://www.reddit.com/r/docker/comments/7xvlye/docker_for_macwindows_performances_vs_linux/)
* [Docker WSL2 backend](https://docs.docker.com/docker-for-windows/wsl-tech-preview/)

## Author

[Yang Deokgyu](secugyu@gmail.com)
