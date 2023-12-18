add_executable(lstextures lstextures.cpp texturefilenameelement.cpp)
set_target_properties(lstextures PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
target_link_libraries(lstextures Coin::Coin)
install(TARGETS lstextures RUNTIME DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/ivexamples_${Gui}/Base)
