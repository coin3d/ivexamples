set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(newManips.cpp.in newManips.cpp @ONLY)
add_executable(08.Manips
${CMAKE_CURRENT_BINARY_DIR}/newManips.cpp
TranslateRadialDragger.cpp
RotTransDragger.cpp
TranslateRadialManip.cpp
RotTransManip.cpp
Coordinate3Manip.cpp
)
set_target_properties(08.Manips PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(08.Manips So${Gui}::So${Gui})
install(TARGETS 08.Manips RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)
