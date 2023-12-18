set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(newNodes.cpp.in newNodes.cpp @ONLY)
configure_file(Pyramid.cpp.in Pyramid.cpp @ONLY)
add_executable(02.Nodes
${CMAKE_CURRENT_BINARY_DIR}/newNodes.cpp 
${CMAKE_CURRENT_BINARY_DIR}/Pyramid.cpp
Glow.cpp
Alternate.cpp
)
set_target_properties(02.Nodes PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(02.Nodes So${Gui}::So${Gui} OpenGL::GL)
install(TARGETS 02.Nodes RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)
