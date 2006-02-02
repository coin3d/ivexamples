############################################################################

BUILT_SOURCES = \
	printVolume.cpp

noinst_PROGRAMS = printVolume

printVolume_SOURCES = printVolume.cpp GetVolumeAction.cpp GetVolumeAction.h


# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac

############################################################################
