############################################################################

BUILT_SOURCES = newNodes.cpp Pyramid.cpp

noinst_PROGRAMS = newNodes

newNodes_SOURCES = \
        Alternate.cpp Alternate.h \
        Glow.cpp Glow.h \
        Pyramid.cpp Pyramid.h \
        newNodes.cpp


# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac

############################################################################
