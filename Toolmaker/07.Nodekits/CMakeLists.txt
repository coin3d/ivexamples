set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file(jumpingJackKitTest.cpp.in jumpingJackKitTest.cpp @ONLY)
add_executable(jumpingJackKitTest
${CMAKE_CURRENT_BINARY_DIR}/jumpingJackKitTest.cpp
JumpingJackKit.cpp
)
target_link_libraries(jumpingJackKitTest So${Gui}::So${Gui})
