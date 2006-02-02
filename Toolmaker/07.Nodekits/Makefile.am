# FIXME: no build set-up for the PyramidKit code yet. 20021220 mortene.

############################################################################

noinst_PROGRAMS = jumpingJackKitTest

BUILT_SOURCES = \
	jumpingJackKitTest.cpp

jumpingJackKitTest_SOURCES = jumpingJackKitTest.cpp JumpingJackKit.cpp JumpingJackKit.h

############################################################################

jumpingJackKitTest.cpp: $(srcdir)/jumpingJackKitTest.cpp.in
	@( cd $(top_builddir); ./config.status --file=Toolmaker/07.Nodekits/jumpingJackKitTest.cpp )


# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac

############################################################################
