## Nordic NRF52 ARM-GCC Development Environment

This project installs docker image that hosts a complete Nordic NRF52 Development Environment with ARM-GCC tooling on a container.
The development environment is setup to run completely on a docker container on Linux.

### Features
- Fully Dockerized ARM-GCC Tooling for Nordic NRF52 with gdb
- Tested on Ubuntu 16.1 or later
- Works with Nordic NRF5x SDK 12 or later
- Openocd gdb server for debugging
- Segger J-Link to download images to target
- Easy to add and expand tools

### Included Scripts

- The bash script **do** manages all the tasks
- The file **rcfile.docker** contains all the firmware project specific settings
- The bash script **build.sh** handles all the tooling in the background
- All the arguments passed to **do** script (except 'up') is forwarded to **build.sh** running on the container

## Setting up Development environment

### Setup up Docker build system
1. Install docker with admin privileges (Instructions on Docker website)
2. Enter the following command to create docker image and install all necessary packages
```
./do up
```
3. Download Nordic SDK and unzip the contents inside **sdk** folder in the top folder (where the *Dockerfile* is located)

## Using build system

1. Edit **rcfile.docker** and modify the **PRJROOT** variable to point to the desired project folder
2. Enter the following command to build the project and flash to target
```
./do flash
```
Alternately, its also possible to run an interactive shell on the docker container and build directly on the container. To login to the docker container, enter:
```
./do bash
```

Project can be built on the docker container using the ***build.sh*** script directly. To build on docker, enter the container in interactive shell, then run enter the following command:

```
./build.sh flash
```

## Debugging the target
To debug the target using gdb, enter the following command
```
./do debug-notui
```
Note that TUI mode will only work when gdb is run in container shell (./do bash)

To run gdb with TUI, login to the container shell and run
```
./build.sh debug
```

Alternately you can also run openocd gdb server and connect to target from Netbeans, eclipse, etc.
To start openocd gdb server, run the following command:
```
./do openocd
```

## Building and flashing DFU bootloader project
Bootloader project path is defined in **rcfile.docker** as ***BTLDR***
After setting the path to the correct folder, the bootloader can be built as follows:
```
./do boot
```
