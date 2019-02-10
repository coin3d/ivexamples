set(CMAKE_INCLUDE_CURRENT_DIR ON)
add_executable(fieldtest main.cpp SFDouble.cpp MFDouble.cpp)
target_link_libraries(fieldtest So${Gui}::So${Gui})
