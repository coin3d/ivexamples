############################################################################

noinst_PROGRAMS = elementtest

elementtest_SOURCES = main.cpp TemperatureElement.cpp TemperatureElement.h


# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac

############################################################################
