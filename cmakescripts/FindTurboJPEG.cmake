include(CheckCSourceCompiles)

if(NOT TJPEG_INCLUDE_DIR)
	set(DEFAULT_TJPEG_INCLUDE_DIR /opt/libjpeg-turbo/include)
else()
	set(DEFAULT_TJPEG_INCLUDE_DIR ${TJPEG_INCLUDE_DIR})
	unset(TJPEG_INCLUDE_DIR)
	unset(TJPEG_INCLUDE_DIR CACHE)
endif()

# Include dir
find_path(TJPEG_INCLUDE_DIR
  NAMES turbojpeg.h
  PATHS /opt/libjpeg-turbo/include
)
# Finally the library itself
find_library(TJPEG_LIBRARY
  NAMES libturbojpeg.so libturbojpeg.so.0 turbojpeg.dll libturbojpeg.dylib
  PATHS ${LibJpegTurbo_PKGCONF_LIBRARY_DIRS} /opt/libjpeg-turbo/lib
)
include_directories(${TJPEG_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TURBOJPEG DEFAULT_MSG
       TJPEG_LIBRARY TJPEG_INCLUDE_DIR)
