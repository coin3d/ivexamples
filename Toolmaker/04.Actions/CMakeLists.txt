set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(printVolume.cpp.in printVolume.cpp @ONLY)
add_executable(printVolume
${CMAKE_CURRENT_BINARY_DIR}/printVolume.cpp 
GetVolumeAction.cpp
)
target_link_libraries(printVolume Coin::Coin So${Gui}::So${Gui})

