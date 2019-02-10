set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(selectionTest.cpp.in selectionTest.cpp @ONLY)
add_executable(selectionTest
${CMAKE_CURRENT_BINARY_DIR}/selectionTest.cpp
ShowSelectionRA.cpp
)
target_link_libraries(selectionTest Coin::Coin So${Gui}::So${Gui})

configure_file(overlayTest.cpp.in overlayTest.cpp @ONLY)
add_executable(overlayTest
${CMAKE_CURRENT_BINARY_DIR}/overlayTest.cpp
OverlayHL.cpp
)
target_link_libraries(overlayTest So${Gui}::So${Gui})
