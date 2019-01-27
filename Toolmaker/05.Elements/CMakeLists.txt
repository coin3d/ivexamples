set(CMAKE_INCLUDE_CURRENT_DIR ON)
add_executable(elementtest main.cpp TemperatureElement.cpp)
target_link_libraries(elementtest Coin::Coin So${Gui}::So${Gui})
