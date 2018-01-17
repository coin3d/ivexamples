cmake_minimum_required (VERSION 3.9.1)
project (ivexamples)

option(HAVE_ASAN  "Link executable with the Address Sanitizer static library" ON)
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
