#  This can be any file in the package.
AC_INIT(Mentor/02.1.HelloCone.cpp.in)
AC_CONFIG_AUX_DIR(cfg)

# **************************************************************************
# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it.

SIM_AC_SETUP_MSVCPP_IFELSE

# **************************************************************************

## CPP needed for the Open Inventor version check.
AC_PROG_CPP
## Locate C++ compiler and set C++ as the default compiler to run
## in tests.
AC_PROG_CXX
AC_LANG(C++)

# *******************************************************************
# * Miscellaneous options and initializations.
# *******************************************************************

AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE(ivexamples, 0.0.1)

#  File to cram results from the configure tests into.
AM_CONFIG_HEADER(config.h)

#  Turn off default maintainer make-rules -- use ./bootstrap instead.
AM_MAINTAINER_MODE

# *******************************************************************
# * Compiler control.
# *******************************************************************

SIM_AC_DEBUGSYMBOLS
SIM_AC_RTTI_SUPPORT
SIM_AC_EXCEPTION_HANDLING
SIM_AC_PROFILING_SUPPORT
SIM_AC_COMPILER_WARNINGS

# *******************************************************************
# * System feature tests.
# *******************************************************************

AC_CHECK_HEADERS([windows.h])

# **************************************************************************
# Search and set up necessary stuff to use the Inventor implementation.

sim_ac_ivexamples_use_inventor=true
if test x"$with_inventor" = x; then sim_ac_ivexamples_use_inventor=false; fi
if test x"$with_inventor" = xno; then sim_ac_ivexamples_use_inventor=false; fi

if $sim_ac_ivexamples_use_inventor; then
  # If we want to compile and link against InventorXt and Inventor, we
  # need to check for a shitload of libraries.

  SIM_AC_CHECK_MATHLIB
  SIM_AC_CHECK_DL
  SIM_AC_CHECK_X11
  
  if test x"$sim_ac_x11_avail" = xyes; then
    SIM_AC_CHECK_X11SHMEM
    SIM_AC_CHECK_X11MU
    SIM_AC_CHECK_X11XID
    SIM_AC_CHECK_X11_XP
    SIM_AC_CHECK_X_INTRINSIC
  fi
  
  SIM_AC_CHECK_OPENGL(
    [SIM_AC_CHECK_HEADER_GLEXT([])], 
    [AC_MSG_ERROR(needs an OpenGL-compatible development system installation)]
  )

  SIM_AC_CHECK_GLU( , AC_MSG_ERROR(needs the GLU library functions))

  SIM_AC_HAVE_INVENTOR_IFELSE(
    [CPPFLAGS="$sim_ac_inventor_cppflags $CPPFLAGS"
     LDFLAGS="$sim_ac_inventor_ldflags $LDFLAGS"
     LIBS="$sim_ac_inventor_libs $LIBS"],
    AC_MSG_ERROR(couldn't compile and link against Open Inventor))
  SIM_CHECK_MOTIF( , AC_MSG_ERROR(couldn't compile and link with Motif))
  SIM_CHECK_MOTIF_GLWIDGET
  
  SIM_CHECK_XMEDRAWSHADOWS
  
  # If XmeDrawShadows() isn't provided by the installed Motif library,
  # we make our own stub. InventorXt uses this function of Motif, but
  # it wasn't provided in earlier versions of Lesstif (because it's a
  # Motif 2.0 function?).
  
  if test x"$sim_ac_xmedrawshadows_avail" = xno; then
    cat > xmedrawshadows.cpp <<EOF
      extern "C" {
      #include <Xm/Xm.h>
      void XmeDrawShadows(Display *, Drawable, GC, GC, Position, Position, Dimension, Dimension, Dimension, unsigned int) { }
      }
EOF
    $CXX -c $CXXFLAGS $CPPFLAGS xmedrawshadows.cpp
    LIBS="$LIBS `pwd`/xmedrawshadows.o"
  fi
  
  SIM_CHECK_OIV_XT( , AC_MSG_ERROR(couldn't compile and link against the InventorXt library))

  AM_CONDITIONAL(HAVE_EXAMINERVIEWER, true)
  AM_CONDITIONAL(HAVE_PLANEVIEWER, true)
  AM_CONDITIONAL(HAVE_WALKVIEWER, true)
  AM_CONDITIONAL(HAVE_FLYVIEWER, true)
  AM_CONDITIONAL(HAVE_SLIDERSETS, true)
  AM_CONDITIONAL(HAVE_MATERIALEDITOR, true)
  AM_CONDITIONAL(HAVE_DIRECTIONALLIGHTEDITOR, true)
  AM_CONDITIONAL(HAVE_MATERIALLIST, true)
  AM_CONDITIONAL(HAVE_PRINTDIALOG, true)

  GUI=XT
  Gui=Xt
  gui=xt
  WIDGET=Widget
  EVENT="XAnyEvent *"
  COMPONENTHEADER=

else
  sim_ac_gui_default=soxt

  test x${with_qt+set} = xset && sim_ac_gui_default=soqt
  test x${with_xt+set} = xset && sim_ac_gui_default=soxt
  test x${with_gtk+set} = xset && sim_ac_gui_default=sogtk

  AC_ARG_WITH(
    soxt,
    AC_HELP_STRING([--with-soxt], [build against the SoXt toolkit]),
    [sim_ac_gui_default=soxt])
  AC_ARG_WITH(
    soqt,
    AC_HELP_STRING([--with-soqt], [build against the SoQt toolkit]),
    [sim_ac_gui_default=soqt])
  AC_ARG_WITH(
    sowin,
    AC_HELP_STRING([--with-sowin], [build against the SoWin toolkit]),
    [sim_ac_gui_default=sowin])
  AC_ARG_WITH(
    sogtk,
    AC_HELP_STRING([--with-sogtk], [build against the SoGtk toolkit]),
    [sim_ac_gui_default=sogtk])

  AC_ARG_WITH(
    toolkit,
    AC_HELP_STRING([--with-toolkit=<toolkit>],
                   [select GUI toolkit to use (default=SoXt)]),
    [lwithval=`echo $withval | tr A-Z a-z`
    case $lwithval in
      xt  | soxt)    sim_ac_gui_toolkit=soxt  ;;
      qt  | soqt)    sim_ac_gui_toolkit=soqt  ;;
      win | sowin)   sim_ac_gui_toolkit=sowin ;;
      gtk | sogtk)   sim_ac_gui_toolkit=sogtk ;;
      be  | sobe)    sim_ac_gui_toolkit=sobe  ;;
      *) AC_MSG_ERROR([invalid --with-toolkit value: "$withval"]) ;;
    esac],
    [sim_ac_gui_toolkit=$sim_ac_gui_default])

  # **************************************************************************
  # Environment variables to configure the generic sourcefiles.

  sim_ac_path=$PATH
  test x"$prefix" = xNONE || sim_ac_path=$prefix/bin:$sim_ac_path

  sim_ac_gui_configcmd=${sim_ac_gui_toolkit}-config
  AC_PATH_PROG(soguiconfig, $sim_ac_gui_configcmd, false, $sim_ac_path)
  if $soguiconfig; then
    GUI=`$soguiconfig --ac-subst GUI`
    Gui=`$soguiconfig --ac-subst Gui`
    gui=`$soguiconfig --ac-subst gui`
    WIDGET=`$soguiconfig --ac-subst WIDGET`
    EVENT=`$soguiconfig --ac-subst EVENT`
    COMPONENTHEADER=`$soguiconfig --ac-subst COMPONENTHEADER`
  else
    SIM_AC_ERROR([unable-to-run-soxx-config])
  fi

  # Which examples to build.

  AM_CONDITIONAL(HAVE_EXAMINERVIEWER, true)
  AM_CONDITIONAL(HAVE_PLANEVIEWER, true)
  AM_CONDITIONAL(HAVE_WALKVIEWER, true)
  AM_CONDITIONAL(HAVE_FLYVIEWER, true)
  AM_CONDITIONAL(HAVE_SLIDERSETS, false)
  AM_CONDITIONAL(HAVE_MATERIALEDITOR, false)
  AM_CONDITIONAL(HAVE_DIRECTIONALLIGHTEDITOR, false)
  AM_CONDITIONAL(HAVE_MATERIALLIST, false)
  AM_CONDITIONAL(HAVE_PRINTDIALOG, false)

  CPPFLAGS="`$soguiconfig --cppflags` $CPPFLAGS"
  LDFLAGS="`$soguiconfig --ldflags` $LDFLAGS"
  LIBS="`$soguiconfig --libs` $LIBS"

  SIM_AC_CHECK_OPENGL(
    [SIM_AC_CHECK_HEADER_GLEXT([])], 
    [AC_MSG_ERROR(needs an OpenGL-compatible development system installation)]
  )
  SIM_AC_CHECK_GLU([], AC_MSG_ERROR(needs the GLU library functions))
fi

if test x"${WINWIDGET+set}" != x"set"; then
  WINWIDGET=$WIDGET
fi

# FIXME: the following blocks for detection and setup of gl.h
# inclusion is copied from Coin's configure.ac. Duplication is
# bad, it should be collected in a shared macro. 20030401 mortene.

# how to include gl.h
if test x"$ac_cv_header_GL_gl_h" = x"yes"; then
  sim_include_gl_h="#include <GL/gl.h>"
else
  if test x"$ac_cv_header_OpenGL_gl_h" = x"yes"; then
    sim_include_gl_h="#include <OpenGL/gl.h>"
  else
    sim_include_gl_h="#error \"don't know how to include gl.h header\""
  fi
fi

# how to include glu.h
if test x"$ac_cv_header_GL_glu_h" = x"yes"; then
  sim_include_glu_h="#include <GL/glu.h>"
else
  if test x"$ac_cv_header_OpenGL_glu_h" = x"yes"; then
    sim_include_glu_h="#include <OpenGL/glu.h>"
  else
    sim_include_glu_h="/* #include <GL/glu.h> - not found on system */"
  fi
fi

# how to include glext.h
if test x"$ac_cv_header_GL_glext_h" = x"yes"; then
  sim_include_glext_h="#include <GL/glext.h>"
else
  if test x"$ac_cv_header_OpenGL_glext_h" = x"yes"; then
    sim_include_glext_h="#include <OpenGL/glext.h>"
  else
    sim_include_glext_h="/* #include <GL/glext.h> - not found on system */"
  fi
fi

AC_SUBST([SIM_INCLUDE_GL_H], [$sim_include_gl_h])
AC_SUBST([SIM_INCLUDE_GLU_H], [$sim_include_glu_h])
AC_SUBST([SIM_INCLUDE_GLEXT_H], [$sim_include_glext_h])


AC_SUBST(GUI)
AC_SUBST(Gui)
AC_SUBST(gui)
AC_SUBST(WIDGET)
AC_SUBST(WINWIDGET)
AC_SUBST(EVENT)
AC_SUBST(COMPONENTHEADER)


# Include Inventor Mentor examples that are Xt/Motif dependent if
# we're building against SoXt or InventorXt.
AM_CONDITIONAL(BUILD_XT_ONLY_EXAMPLES, test "$Gui" = "Xt")


# *******************************************************************
# * All files configure must automatically generate.
# *******************************************************************

AC_OUTPUT([
	Makefile
	Base/Makefile
	Base/elements/Makefile
	Mentor/Makefile
	Mentor/02.1.HelloCone.cpp
	Mentor/02.2.EngineSpin.cpp
	Mentor/02.3.Trackball.cpp
	Mentor/02.4.Examiner.cpp
	Mentor/03.1.Molecule.cpp
	Mentor/03.2.Robot.cpp
	Mentor/03.3.Naming.cpp
	Mentor/04.1.Cameras.cpp
	Mentor/04.2.Lights.cpp
	Mentor/05.1.FaceSet.cpp
	Mentor/05.2.IndexedFaceSet.cpp
	Mentor/05.3.TriangleStripSet.cpp
	Mentor/05.4.QuadMesh.cpp
	Mentor/05.5.Binding.cpp
	Mentor/05.6.TransformOrdering.cpp
	Mentor/06.1.Text.cpp
	Mentor/06.2.Simple3DText.cpp
	Mentor/06.3.Complex3DText.cpp
	Mentor/07.1.BasicTexture.cpp
	Mentor/07.2.TextureCoordinates.cpp
	Mentor/07.3.TextureFunction.cpp
	Mentor/08.1.BSCurve.cpp
	Mentor/08.2.UniCurve.cpp
	Mentor/08.3.BezSurf.cpp
	Mentor/08.4.TrimSurf.cpp
	Mentor/09.1.Print.cpp
	Mentor/09.2.Texture.cpp
	Mentor/09.3.Search.cpp
	Mentor/09.4.PickAction.cpp
	Mentor/09.5.GenSph.cpp
	Mentor/10.1.addEventCB.cpp
	Mentor/10.2.setEventCB.cpp
	Mentor/10.3and4.MotifList.cpp
	Mentor/10.5.SelectionCB.cpp
	Mentor/10.6.PickFilterTopLevel.cpp
	Mentor/10.7.PickFilterManip.cpp
	Mentor/10.8.PickFilterNodeKit.cpp
	Mentor/11.1.ReadFile.cpp
	Mentor/11.2.ReadString.cpp
	Mentor/12.1.FieldSensor.cpp
	Mentor/12.2.NodeSensor.cpp
	Mentor/12.3.AlarmSensor.cpp
	Mentor/12.4.TimerSensor.cpp
	Mentor/13.1.GlobalFlds.cpp
	Mentor/13.2.ElapsedTime.cpp
	Mentor/13.3.TimeCounter.cpp
	Mentor/13.4.Gate.cpp
	Mentor/13.5.Boolean.cpp
	Mentor/13.6.Calculator.cpp
	Mentor/13.7.Rotor.cpp
	Mentor/13.8.Blinker.cpp
	Mentor/14.1.FrolickingWords.cpp
	Mentor/14.2.Editors.cpp
	Mentor/14.3.Balance.cpp
	Mentor/15.1.ConeRadius.cpp
	Mentor/15.2.SliderBox.cpp
	Mentor/15.3.AttachManip.cpp
	Mentor/15.4.Customize.cpp
	Mentor/16.1.Overlay.cpp
	Mentor/16.2.Callback.cpp
	Mentor/16.3.AttachEditor.cpp
	Mentor/16.4.OneWindow.cpp
	Mentor/16.5.Examiner.cpp
	Mentor/17.1.ColorIndex.cpp
	Mentor/17.2.GLCallback.cpp
	Mentor/17.3.GLFloor.cpp
	Toolmaker/Makefile
	Toolmaker/02.Nodes/Makefile
	Toolmaker/02.Nodes/newNodes.cpp
	Toolmaker/02.Nodes/Pyramid.cpp
	Toolmaker/03.Fields/Makefile
	Toolmaker/04.Actions/Makefile
	Toolmaker/04.Actions/printVolume.cpp
	Toolmaker/05.Elements/Makefile
	Toolmaker/07.Nodekits/Makefile
])

echo ""
echo "Now run 'make' to build the examples."
case $target_os in
  darwin* ) 
    echo "Run 'make app-bundles' to create Mac OS X application bundles."
    ;; 
esac
echo ""


