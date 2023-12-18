set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(jumpingJackKitTest.cpp.in jumpingJackKitTest.cpp @ONLY)
add_executable(07.Nodekits
${CMAKE_CURRENT_BINARY_DIR}/jumpingJackKitTest.cpp
JumpingJackKit.cpp
)
set_target_properties(07.Nodekits PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(07.Nodekits So${Gui}::So${Gui})
install(TARGETS 07.Nodekits RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)
