set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_directories(BEFORE CMAKE_CURRENT_BINARY_DIR)

configure_file(viewer.cpp.in viewer.cpp @ONLY)
configure_file(simpleViewer.h.in simpleViewer.h @ONLY)
configure_file(simpleViewer.cpp.in simpleViewer.cpp @ONLY)

# add_executable(viewer
# ${CMAKE_CURRENT_BINARY_DIR}/viewer.cpp
# ${CMAKE_CURRENT_BINARY_DIR}/simpleViewer.cpp
# )
# target_link_libraries(viewer Coin::Coin So${Gui}::So${Gui})

if (Gui STREQUAL "Xt")
  configure_file(SceneTumble.h.in SceneTumble.h @ONLY)
  configure_file(SceneTumble.cpp.in SceneTumble.cpp @ONLY)
  configure_file(tumble.cpp.in tumble.cpp @ONLY)
  add_executable(tumble
  ${CMAKE_CURRENT_BINARY_DIR}/tumble.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/SceneTumble.cpp
  )
  target_link_libraries(tumble So${Gui}::So${Gui} X11::Xt)
endif()
