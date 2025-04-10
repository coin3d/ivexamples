cmake_minimum_required(VERSION 3.9.1...3.29)

set(CMAKE_CXX_STANDARD 11)

# Add path for Coin specific utility scripts
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" "${CMAKE_MODULE_PATH}")

project(ivexamples VERSION 1.0.0 DESCRIPTION "Examples from Inventor Mentor and Inventor Toolmaker.")

if(POLICY CMP0072)
  # get rid of OpenGL GLVND warning from CMake 3.11
  cmake_policy(SET CMP0072 NEW)
endif()

# ############################################################################
# CMake module includes
# ############################################################################

include(GNUInstallDirs)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckIncludeFileCXX)
include(CoinCMakeUtilities)

coin_setup_gui_project()

# ############################################################################
# Provide options to customise the build
# ############################################################################

option(HAVE_ASAN "Link executable with the Address Sanitizer static library" OFF)
option(HAVE_DEBUG "Add debugging information during the configure process" OFF)

if(HAVE_ASAN)
  find_library(ASAN_LIBRARY NAMES libasan.so.4)
  if(NOT ASAN_LIBRARY)
    MESSAGE(WARNING "address sanitizer not installed.")
  else()
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=address")
  endif()
endif()

# ############################################################################
# Target environment checks
# ############################################################################

check_include_file(windows.h HAVE_WINDOWS_H)
set(CMAKE_REQUIRED_INCLUDES "${OPENGL_INCLUDE_DIR}")
chk_gl_include_file(GL_H    gl.h)
chk_gl_include_file(GLU_H   glu.h)
chk_gl_include_file(GLEXT_H glext.h gl.h)
chk_gl_include_file(GLX_H   glx.h)
set(CMAKE_REQUIRED_INCLUDES)

find_package(OpenGL REQUIRED)
find_package(Coin REQUIRED)
find_package(So${Gui} REQUIRED)
if(Gui STREQUAL "Xt")
  find_package(Motif REQUIRED)
  find_package(X11 REQUIRED COMPONENTS Xt)
endif()

dump_variable(
Coin_INCLUDE_DIR
So${Gui}_INCLUDE_DIRS
OPENGL_INCLUDE_DIR
SIM_INCLUDE_GL_H
SIM_INCLUDE_GLU_H
SIM_INCLUDE_GLX_H
SIM_INCLUDE_GLEXT_H
)

# ############################################################################
# Project setup
# ############################################################################

configure_file(config.h.cmake.in config.h)
add_compile_definitions(HAVE_CONFIG_H=1)
if(WIN32)
  set(CMAKE_DEBUG_POSTFIX "d")
endif()

# Add header directories
include_directories(BEFORE ${CMAKE_BINARY_DIR})

add_subdirectory(Base)
add_subdirectory(Mentor)
add_subdirectory(Toolmaker)
