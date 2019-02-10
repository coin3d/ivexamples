set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(newManips.cpp.in newManips.cpp @ONLY)
add_executable(newManips
${CMAKE_CURRENT_BINARY_DIR}/newManips.cpp
TranslateRadialDragger.cpp
RotTransDragger.cpp
TranslateRadialManip.cpp
RotTransManip.cpp
Coordinate3Manip.cpp
)
target_link_libraries(newManips So${Gui}::So${Gui})
