# ****************************************************************************
#  Project:  HtmlGrapheas
#  Purpose:  HTML text editor library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2018 NikitaFeodonit
#
#    This file is part of the HtmlGrapheas project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

include(cmr_print_message)

#-----------------------------------------------------------------------
# Build, install and find FreeType and HarfBuzz libraries
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Set vars for LibCMaker_FreeType and LibCMaker_HarfBuzz.
#-----------------------------------------------------------------------

# Needed for lib_cmaker_harfbuzz() to build HarfBuzz with FreeType.
set(LIBCMAKER_FREETYPE_SRC_DIR "${EXTERNAL_SRC_DIR}/LibCMaker_FreeType")
# To use our FindFreetype.cmake.
list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FREETYPE_SRC_DIR}/cmake/")

set(FT_lib_VERSION "2.8.1")

set(FT_DOWNLOAD_DIR "${EXTERNAL_DOWNLOAD_DIR}")
set(FT_UNPACKED_SRC_DIR "${EXTERNAL_UNPACKED_SRC_DIR}")
set(FT_BUILD_DIR "${EXTERNAL_BIN_DIR}/build_freetype")

# Library specific vars.
set(FREETYPE_NO_DIST ON)

set(WITH_ZLIB OFF)
set(WITH_BZip2 OFF)
set(WITH_PNG OFF)
set(WITH_HarfBuzz ON)

# Needed to find FreeType in lib_cmaker_harfbuzz() and here.
set(ENV{FREETYPE_DIR} "${EXTERNAL_INSTALL_DIR}")

if(WITH_HarfBuzz)
  # Needed for lib_cmaker_freetype() to build HarfBuzz.
  set(LIBCMAKER_HARFBUZZ_SRC_DIR
    "${EXTERNAL_SRC_DIR}/LibCMaker_HarfBuzz")
  # To use our FindHarfBuzz.cmake.
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/")

  set(HB_lib_VERSION "1.6.3")

  set(HB_DOWNLOAD_DIR "${EXTERNAL_DOWNLOAD_DIR}")
  set(HB_UNPACKED_SRC_DIR "${EXTERNAL_UNPACKED_SRC_DIR}")
  set(HB_BUILD_DIR "${EXTERNAL_BIN_DIR}/build_harfbuzz")

  # Needed to find HarfBuzz in lib_cmaker_freetype() and here.
  set(ENV{HARFBUZZ_DIR} "${EXTERNAL_INSTALL_DIR}")
endif()

#-----------------------------------------------------------------------
# Build and install the FreeType (and HarfBuzz in lib_cmaker_freetype()).
#-----------------------------------------------------------------------

# Try to find already installed libs.
find_package(Freetype QUIET)
if(WITH_HarfBuzz)
  find_package(HarfBuzz QUIET)
endif()

if(NOT FREETYPE_FOUND OR (WITH_HarfBuzz AND NOT HarfBuzz_FOUND))
  if(WITH_HarfBuzz)
    cmr_print_message(
      "FreeType or HarfBuzz are not installed, build and install them.")
  else()
    cmr_print_message(
      "FreeType is not installed, build and install it.")
  endif()

  include(${EXTERNAL_SRC_DIR}/LibCMaker_FreeType/lib_cmaker_freetype.cmake)
  lib_cmaker_freetype(
    VERSION ${FT_lib_VERSION}
    DOWNLOAD_DIR ${FT_DOWNLOAD_DIR}
    UNPACKED_SRC_DIR ${FT_UNPACKED_SRC_DIR}
    BUILD_DIR ${FT_BUILD_DIR}
  )
  
  find_package(Freetype REQUIRED)
  if(WITH_HarfBuzz)
    find_package(HarfBuzz REQUIRED)
  endif()
  
else()
  if(WITH_HarfBuzz)
    cmr_print_message(
      "FreeType and HarfBuzz are installed, skip building and installing them.")
  else()
    cmr_print_message(
      "FreeType is installed, skip building and installing it.")
  endif()
endif()