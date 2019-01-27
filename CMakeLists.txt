cmake_minimum_required (VERSION 3.9.1)

# ############################################################################
# GUI target preliminary setup
# ############################################################################
set(Gui "Qt" CACHE STRING "Target GUI for the Open Inventor examples")
set(GuiValues "Qt;Xt;Win" CACHE INTERNAL "List of possible values for the GUI cache variable")
set_property(CACHE Gui PROPERTY STRINGS ${GuiValues})
message(STATUS "Gui='${Gui}'")
if (Gui STREQUAL "Qt")
  set(WINWIDGET QWidget*)
elseif(Gui STREQUAL "Xt")
  set(WINWIDGET Widget)
elseif(Gui STREQUAL "Win")
  set(WINWIDGET HWND)
else()
  message(FATAL_ERROR "Only Qt,Win and Xt supported: please set Gui at one of these values")
endif()
# ############################################################################

project (ivexamples VERSION 1.0.0)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

# ############################################################################
# these will be removed after upgrading CMake minimum version to 3.9.6
set(PROJECT_DESCRIPTION   "Examples from Inventor Mentor and Inventor Toolmaker.")
# ############################################################################
 
string(TIMESTAMP SO${GUI}EXAMPLES_BUILD_YEAR "%Y")

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

option(HAVE_ASAN  "Link executable with the Address Sanitizer static library" OFF)
option(HAVE_DEBUG "Add debugging information during the configure process")
option(DOTRACE    "Enable code tracing")
if (DOTRACE)
  add_definitions(-DDOTRACE)
endif(DOTRACE)

if (HAVE_ASAN)
  find_library(ASAN_LIBRARY NAMES libasan.so.4)
  if (NOT ASAN_LIBRARY)
    MESSAGE(WARNING "address sanitizer not installed.")
  else (NOT ASAN_LIBRARY)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=address")
  endif (NOT ASAN_LIBRARY)
endif(HAVE_ASAN)

# ############################################################################
# Macros & functions
# ############################################################################

function(dump_variable)
  if (HAVE_DEBUG)
    foreach(f ${ARGN})
      message("${f} = ${${f}}")
    endforeach()
  endif(HAVE_DEBUG)
endfunction(dump_variable)

function(chk_gl_include_file VAR INCLUDE)
  foreach(f ${ARGN})
    list(APPEND GL_INCLUDES     "GL/${f}")
    list(APPEND OPENGL_INCLUDES "OpenGL/${f}")
  endforeach()
  list(APPEND GL_INCLUDES     "GL/${INCLUDE}")
  list(APPEND OPENGL_INCLUDES "OpenGL/${INCLUDE}")
  dump_variable(
  VAR
  INCLUDE
  GL_INCLUDES
  OPENGL_INCLUDES
  )
  check_include_files("${GL_INCLUDES}"     HAVE_GL_${VAR}     LANGUAGE CXX)
  check_include_files("${OPENGL_INCLUDEs}" HAVE_OPENGL_${VAR} LANGUAGE CXX)
  if (HAVE_GL_${VAR})
    set(SIM_INCLUDE_${VAR} "#include <GL/${INCLUDE}>" PARENT_SCOPE)
  elseif (HAVE_OPENGL_${VAR})
    set(SIM_INCLUDE_${VAR} "#include <OpenGL/${INCLUDE}>" PARENT_SCOPE)
  else ()
    set(SIM_INCLUDE_${VAR} "#error \"don't know how to include ${INCLUDE} header\"" PARENT_SCOPE)
  endif()
endfunction(chk_gl_include_file)

# ############################################################################
# Target environment checks
# ############################################################################

chk_gl_include_file(GL_H    gl.h)
chk_gl_include_file(GLU_H   glu.h)
chk_gl_include_file(GLEXT_H glext.h gl.h)
chk_gl_include_file(GLX_H   glx.h)

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

#Add header directories
include_directories(BEFORE
  ${So${Gui}_INCLUDE_DIRS}
  ${Coin_INCLUDE_DIR}
  ${OPENGL_INCLUDE_DIR}
)

add_subdirectory(Base)
add_subdirectory(Mentor)
add_subdirectory(Toolmaker)
