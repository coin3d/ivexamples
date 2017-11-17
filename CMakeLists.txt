cmake_minimum_required (VERSION 3.9.1)
project (ivexamples)

option(HAVE_DEBUG "Add debugging information during the configure process")
option(DOTRACE    "Enable code tracing")
if (DOTRACE)
  add_definitions(-DDOTRACE)
endif(DOTRACE)

function(dump_variable)
  if (HAVE_DEBUG)
    foreach(f ${ARGN})
      message("${f} = ${${f}}")
    endforeach()
  endif(HAVE_DEBUG)
endfunction(dump_variable)

find_package(Coin REQUIRED CONFIG)
find_package(Qt5  REQUIRED COMPONENTS Widgets)
find_package(SoQt REQUIRED CONFIG)
dump_variable(
Coin_DIR
Coin_DEFINES
Coin_INCLUDE_DIR
Qt5Widgets_EXECUTABLE_COMPILE_FLAGS
)
set(Gui Qt)
set(WINWIDGET "QWidget *")
set(top_srcdir "${PROJECT_SOURCE_DIR}")
include_directories(BEFORE ${Qt5Widgets_INCLUDE_DIRS} ${Coin_INCLUDE_DIR})

add_subdirectory(Base)
add_subdirectory(Mentor)
add_subdirectory(Toolmaker)
