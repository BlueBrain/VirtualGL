Building VirtualGL
==================


Build Requirements
------------------


### All Systems

- [CMake](http://www.cmake.org) v2.8.11 or later

- If building SSL support:
  * [OpenSSL](http://www.OpenSSL.org) -- see "Building SSL Support" below

- libjpeg-turbo SDK v1.1.1 or later
  * The libjpeg-turbo SDK binary packages can be downloaded from the "Files"
    area of <http://sourceforge.net/projects/libjpeg-turbo>.
  * The VirtualGL build system will search for the TurboJPEG header and
    library under /opt/libjpeg-turbo on Unix (including Cygwin) or
    c:\libjpeg-turbo[64] on Windows, but you can override this by setting the
    `TJPEG_INCLUDE_DIR` CMake variable to the directory containing turbojpeg.h
    and the `TJPEG_LIBRARY` CMake variable to either the full path of the
    TurboJPEG library against which you want to link or a set of link flags
    needed to link with the TurboJPEG library (for instance,
    `-DTJPEG_LIBRARY="-L{dir} -lturbojpeg"`.)


### Linux or FreeBSD

- GCC and G++

- X11 and OpenGL development libraries:
  * libX11, libXext, libGL, libGLU, and (if you wish to enable X Video
    support) libXv


### Mac

- Xcode Tools
  * Available on the OS X install discs or from:
    <http://developer.apple.com/tools/xcode>
  * With earlier versions of Xcode, you will need to specify a custom install
    and select the following packages:
    gcc 3.x (or later), X11 SDK, OpenGL SDK, Mac OS X SDK
  * With Xcode 3.x and later, you can simply check "Unix Development Support"
  * With Xcode 4.x and later, the X11 and GLX headers and link libraries are
    no longer included.  You can obtain these by installing
    [XQuartz](http://xquartz.macosforge.org).


### Windows

- Cygwin or Cygwin64 with the following packages:
  * GCC and G++
  * X11 and OpenGL development libraries:
    libX11, libXext, libGL, and libGLU
  * libturbojpeg-devel
    (Both Cygwin and Cygwin64 provide the TurboJPEG API DLL for libjpeg-turbo,
    so you can optionally build against this rather than the official
    libjpeg-turbo SDK.)


32-bit VirtualGL Builds on x86-64 Linux Distributions
-----------------------------------------------------

In order to run 32-bit OpenGL applications using VirtualGL on a 64-bit Linux
platform, it is necessary to build both 32-bit and 64-bit versions of the
VirtualGL server components.  However, most recent x86-64 Linux distributions
do not ship with the 32-bit libraries necessary to build a 32-bit version of
VirtualGL.  To build 32-bit VirtualGL components on an x86-64 Linux system, you
will need, at minimum, the following 32-bit development libraries:

- glibc and libstdc++
- X11 and OpenGL
  * libX11, libXext, libGL, libGLU, and (unless you wish to disable X Video
    support) libXv

Instructions for installing these on specific distributions:

### Red Hat Enterprise Linux 6+ (and work-alikes), Recent Fedora Releases

- Follow the procedure described in the VirtualGL User's Guide for installing
  a 32-bit VirtualGL package on x86-64 Linux distributions, then execute the
  following command as root:

        yum install libXv-devel.i686 libXext-devel.i686 libX11-devel.i686 mesa-libGLU-devel.i686 mesa-libGL-devel.i686 glibc-devel.i686 libstdc++-devel.i686 libstdc++-static.i686

  (Replace `yum` with `dnf` on Fedora 23 and later.)

### Ubuntu 12 and later

- Follow the procedure described in the VirtualGL User's Guide for installing
  a 32-bit VirtualGL package on x86-64 Linux distributions, then execute the
  following command as root:

        apt-get install g++-multilib libxv-dev:i386 libglu1-mesa-dev:i386

  In Ubuntu 12 through 15, some of the 32-bit dev. kits have conflicts with
  their 64-bit counterparts, so it is not possible to build a 32-bit and a
  64-bit version of VirtualGL simultaneously on those platforms.  It will be
  necessary to run the above command (as root) prior to performing a 32-bit
  build and the following command (also as root) prior to performing a 64-bit
  build:

        apt-get install libxv-dev libglu1-mesa-dev


Out-of-Tree Builds
------------------

Binary objects, libraries, and executables are generated in the same directory
from which CMake was executed (the "binary directory"), and this directory need
not necessarily be the same as the VirtualGL source directory.  You can create
multiple independent binary directories, in which different versions of
VirtualGL can be built from the same source tree using different compilers or
settings.  In the sections below, *{build_directory}* refers to the binary
directory, whereas *{source_directory}* refers to the VirtualGL source
directory.  For in-tree builds, these directories are the same.


Build Procedure
---------------

The following procedure will build the VirtualGL Client and, on Linux and other
Un*x variants (except OS X), the VirtualGL Server components.  On most 64-bit
systems (Solaris being a notable exception), this will build a 64-bit version
of VirtualGL.  See "Build Recipes" for specific instructions on how to build a
32-bit or 64-bit version of VirtualGL on systems that support both.

    cd {build_directory}
    cmake -G "Unix Makefiles" [additional CMake flags] {source_directory}
    make


Debug Build
-----------

Add `-DCMAKE_BUILD_TYPE=Debug` to the CMake command line.


Building Secure Sockets Layer (SSL) Support
-------------------------------------------

If built with SSL support, VirtualGL can use OpenSSL to encrypt the traffic it
sends and receives via the VGL Transport.  This is only a marginally useful
feature, however, since VirtualGL can also tunnel the VGL Transport through
SSH.  To enable SSL support, set the `VGL_USESSL` CMake variable to `1`.

In general, if you are building on a Unix-ish platform that has the OpenSSL
link libraries and include files installed in the standard system locations,
then the VirtualGL build system should detect the system version of OpenSSL
automatically and link against it.  However, this produces a version of
VirtualGL that depends on the OpenSSL dynamic libraries, and thus the VirtualGL
binaries are not necessarily portable.  Thus, to build a fully portable,
cross-compatible version of VirtualGL with SSL support, it is necessary on most
systems to link against the OpenSSL static libraries.  The following sections
describe how to do that on various platforms.


### Linux

There is generally no sane way to statically link with OpenSSL on Linux without
building OpenSSL from source.  Some distributions of Linux ship with the
OpenSSL static libraries, but these usually depend on Kerberos, which
introduces a long list of dependencies, some of which aren't available in
static library form.  To build OpenSSL from source:

* Download the latest OpenSSL source tarball from <http://www.OpenSSL.org>
* Extract the tarball
* cd to the OpenSSL source directory and issue one of the following commands to
  configure the OpenSSL build:

    **64-bit:**

      ./Configure linux-x86_64 shared no-krb5 no-dso

    **32-bit:**

      ./Configure -m32 linux-generic32 shared no-krb5 no-dso

* `make`

You can then manipulate the `OPENSSL_INCLUDE_DIR`, `OPENSSL_SSL_LIBRARY`, and
`OPENSSL_CRYPTO_LIBRARY` CMake variables to link VirtualGL against your custom
OpenSSL build.  For instance, adding

    -DVGL_USESSL=1 -DOPENSSL_INCLUDE_DIR=~/openssl/include \
      -DOPENSSL_SSL_LIBRARY=~/openssl/libssl.a \
      -DOPENSSL_CRYPTO_LIBRARY=~/openssl/libcrypto.a

to the CMake command line will cause VirtualGL to be statically linked against
a custom build of OpenSSL that resides under ~/openssl.


### Mac

Linking with the OpenSSL dynamic libraries is generally not a concern on OS X,
since Apple ships several versions of these in order to retain backward
compatibility with prior versions of OS X.  See the "Build Recipes" section for
instructions on how to build a backward-compatible version of VirtualGL for
OS X.


### Solaris

The easiest approach on Solaris is to install the OpenSSL development libraries
from [OpenCSW](http://www.OpenCSW.org).  You can then add one of the following
to the CMake command line to statically link VirtualGL with OpenSSL:

  **64-bit:**

    -DVGL_USESSL=1 -DOPENSSL_INCLUDE_DIR=/opt/csw/include \
      -DOPENSSL_SSL_LIBRARY=/opt/csw/lib/64/libssl.a \
      -DOPENSSL_CRYPTO_LIBRARY=/opt/csw/lib/64/libcrypto.a

  **32-bit:**

    -DVGL_USESSL=1 -DOPENSSL_INCLUDE_DIR=/opt/csw/include \
      -DOPENSSL_SSL_LIBRARY=/opt/csw/lib/libssl.a \
      -DOPENSSL_CRYPTO_LIBRARY=/opt/csw/lib/libcrypto.a


### Windows (Cygwin)

Add the following to the CMake command line to statically link VirtualGL with
OpenSSL:

    -DVGL_USESSL=1 -DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.a \
      -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.a;/usr/lib/libz.a


Build Recipes
-------------


### 32-bit Build on 64-bit Linux/Unix (including OS X)

Use export/setenv to set the following environment variables before running
CMake:

    CFLAGS=-m32
    CXXFLAGS=-m32
    LDFLAGS=-m32


### 64-bit Backward-Compatible Build on 64-bit OS X

Add

    -DCMAKE_OSX_SYSROOT=/Developer/SDKs/MacOSX10.5.sdk \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.5

to the CMake command line.  The OS X 10.5 SDK must be installed.


### 32-bit Backward-Compatible Build on 64-bit OS X

Use export/setenv to set the following environment variables:

    CFLAGS=-m32
    CXXFLAGS=-m32
    LDFLAGS=-m32

and add

    -DCMAKE_OSX_SYSROOT=/Developer/SDKs/MacOSX10.5.sdk \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.5

to the CMake command line.  The OS X 10.5 SDK must be installed.


### 64-bit Build on Solaris

Use export/setenv to set the following environment variables before running
CMake:

    CFLAGS=-m64
    CXXFLAGS=-m64
    LDFLAGS=-m64


### Compilers Other Than GCC

On Un*x systems, prior to running CMake, you can set the `CC` environment
variable to the command used to invoke the C compiler and the `CXX` environment
variable to the command used to invoke the C++ compiler.


Advanced CMake Options
----------------------

To list and configure other CMake options not specifically mentioned in this
guide, run

    ccmake {source_directory}

or

    cmake-gui {source_directory}

after initially configuring the build.  CCMake is a text-based interactive
version of CMake, and CMake-GUI is a GUI version.  Both will display all
variables that are relevant to the VirtualGL build, their current values, and a
help string describing what they do.


Installing VirtualGL
====================

You can use the build system to install VirtualGL into a directory of your
choosing.  To do this, add:

    -DCMAKE_INSTALL_PREFIX={install_directory}

to the CMake command line.  Then, you can run `make install` to build and
install VirtualGL.  Running `make uninstall` will uninstall VirtualGL.

If you don't specify `CMAKE_INSTALL_PREFIX`, then the default is
`/opt/VirtualGL`.


Creating Release Packages
=========================

The following commands can be used to create various types of release packages:

`make rpm`

  Create Red Hat-style binary RPM package.  Requires RPM v4 or later.

`make deb`

  Create Debian-style binary package.  Requires dpkg.

`make dmg`

  Create Macintosh package/disk image.  This requires pkgbuild and
  productbuild, which are installed by default on OS X 10.7 and later and which
  can be obtained by installing Xcode 3.2.6 (with the "Unix Development"
  option) on OS X 10.6.  Packages built in this manner can be installed on OS X
  10.5 and later, but they must be built on OS X 10.6 or later.

`make udmg`

  On 64-bit OS X systems, this creates a version of the Macintosh package and
  disk image that contains universal i386/x86-64 binaries.  You should first
  configure a 32-bit out-of-tree build of VirtualGL, then configure a 64-bit
  out-of-tree build, then run `make udmg` from the 64-bit build directory.  The
  build system will look for the 32-bit build under *{source_directory}*/osxx86
  by default, but you can override this by setting the `VGL_32BIT_BUILD` CMake
  variable.

`make cygwinpkg`

  Build a Cygwin binary package.
