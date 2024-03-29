macro(coin_setup_gui_project)
  string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
  string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

  # ############################################################################
  # GUI target preliminary setup
  set(Gui "Qt" CACHE STRING "Target GUI for the Open Inventor examples")
  set(GuiValues "Qt;Xt;Win;Wx" CACHE INTERNAL "List of possible values for the GUI cache variable")
  set_property(CACHE Gui PROPERTY STRINGS ${GuiValues})
  message(STATUS "Gui='${Gui}'")
  if (Gui STREQUAL "Qt")
    set(WINWIDGET QWidget*)
  elseif(Gui STREQUAL "Xt")
    set(WINWIDGET Widget)
  elseif(Gui STREQUAL "Win")
    set(WINWIDGET HWND)
  elseif(Gui STREQUAL "Wx")
    set(WINWIDGET wxWindow*)
  else()
    message(FATAL_ERROR "Only Qt, Win, Wx and Xt supported: please set Gui to one of these values")
  endif()
  string(TOUPPER ${Gui} GUI)
  # ############################################################################

  string(TIMESTAMP PROJECT_BUILD_YEAR "%Y")
endmacro()

# option controlled helper for cmake variable dumping during config
function(dump_variable)
  if (HAVE_DEBUG)
    foreach(f ${ARGN})
      if (DEFINED ${f})
        message("${f} = ${${f}}")
      else()
        message("${f} = ***UNDEF***")
      endif()
    endforeach()
  endif()
endfunction()

function(chk_gl_include_file VAR INCLUDE)
  foreach(f ${ARGN})
    list(APPEND GL_INCLUDES     "GL/${f}")
    list(APPEND OPENGL_INCLUDES "OpenGL/${f}")
  endforeach()
  list(APPEND GL_INCLUDES     "GL/${INCLUDE}")
  list(APPEND OPENGL_INCLUDES "OpenGL/${INCLUDE}")
  dump_variable(
    VAR
    INCLUDE
    GL_INCLUDES
    OPENGL_INCLUDES
  )
  if(HAVE_WINDOWS_H)
    check_include_files("windows.h;${GL_INCLUDES}"     HAVE_GL_${VAR}     LANGUAGE CXX)
    check_include_files("windows.h;${OPENGL_INCLUDES}" HAVE_OPENGL_${VAR} LANGUAGE CXX)
  else()
    check_include_files("${GL_INCLUDES}"     HAVE_GL_${VAR}     LANGUAGE CXX)
    check_include_files("${OPENGL_INCLUDES}" HAVE_OPENGL_${VAR} LANGUAGE CXX)
  endif()
  if (HAVE_GL_${VAR})
    set(SIM_INCLUDE_${VAR} "#include <GL/${INCLUDE}>" PARENT_SCOPE)
  elseif (HAVE_OPENGL_${VAR})
    set(SIM_INCLUDE_${VAR} "#include <OpenGL/${INCLUDE}>" PARENT_SCOPE)
  else ()
    set(SIM_INCLUDE_${VAR} "#error \"don't know how to include ${INCLUDE} header\"" PARENT_SCOPE)
  endif()
endfunction()

