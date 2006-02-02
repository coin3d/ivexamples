############################################################################

noinst_PROGRAMS = fieldtest

fieldtest_SOURCES = main.cpp SFDouble.cpp SFDouble.h MFDouble.cpp MFDouble.h


# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac

############################################################################
