set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(printVolume.cpp.in printVolume.cpp @ONLY)
add_executable(04.Actions
${CMAKE_CURRENT_BINARY_DIR}/printVolume.cpp 
GetVolumeAction.cpp
)
set_target_properties(04.Actions PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(04.Actions So${Gui}::So${Gui})
install(TARGETS 04.Actions RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)
