cmake_minimum_required (VERSION 3.9.1)

# Add path for Coin specific utility scripts
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" "${CMAKE_MODULE_PATH}")
include(CoinCMakeUtilities)

coin_project(ivexamples VERSION 1.0.0 DESCRIPTION "Examples from Inventor Mentor and Inventor Toolmaker.")

if(POLICY CMP0072)
  # get rid of OpenGL GLVND warning from CMake 3.11
  cmake_policy(SET CMP0072 NEW)
endif()

# ############################################################################
# CMake module includes
# ############################################################################

include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckIncludeFileCXX)

# ############################################################################
# Provide options to customise the build
# ############################################################################

option(HAVE_ASAN  "Link executable with the Address Sanitizer static library")
option(HAVE_DEBUG "Add debugging information during the configure process")

if (HAVE_ASAN)
  find_library(ASAN_LIBRARY NAMES libasan.so.4)
  if (NOT ASAN_LIBRARY)
    MESSAGE(WARNING "address sanitizer not installed.")
  else (NOT ASAN_LIBRARY)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=address")
  endif (NOT ASAN_LIBRARY)
endif(HAVE_ASAN)

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
find_package(Motif)
find_package(X11)

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

#Add header directories
include_directories(BEFORE
#  ${So${Gui}_INCLUDE_DIRS}
#  ${Coin_INCLUDE_DIR}
#  ${OPENGL_INCLUDE_DIR}
  ${CMAKE_BINARY_DIR}
)

add_subdirectory(Base)
add_subdirectory(Mentor)
add_subdirectory(Toolmaker)
