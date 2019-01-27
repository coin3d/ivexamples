set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(newNodes.cpp.in newNodes.cpp @ONLY)
configure_file(Pyramid.cpp.in Pyramid.cpp @ONLY)
add_executable(newNodes
${CMAKE_CURRENT_BINARY_DIR}/newNodes.cpp 
${CMAKE_CURRENT_BINARY_DIR}/Pyramid.cpp
Glow.cpp
Alternate.cpp
)
target_link_libraries(newNodes Coin::Coin So${Gui}::So${Gui})
