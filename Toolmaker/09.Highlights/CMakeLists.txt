set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(selectionTest.cpp.in selectionTest.cpp @ONLY)
add_executable(09.Highlights_Selection
${CMAKE_CURRENT_BINARY_DIR}/selectionTest.cpp
ShowSelectionRA.cpp
)
set_target_properties(09.Highlights_Selection PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(09.Highlights_Selection Coin::Coin So${Gui}::So${Gui})
install(TARGETS 09.Highlights_Selection RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)

configure_file(overlayTest.cpp.in overlayTest.cpp @ONLY)
add_executable(09.Highlights_Overlay
${CMAKE_CURRENT_BINARY_DIR}/overlayTest.cpp
OverlayHL.cpp
)
set_target_properties(09.Highlights_Overlay PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(09.Highlights_Overlay So${Gui}::So${Gui})
install(TARGETS 09.Highlights_Overlay RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Toolmaker)
