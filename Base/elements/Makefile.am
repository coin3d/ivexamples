## Process this file with automake to generate Makefile.in.

noinst_PROGRAMS = lstextures
lstextures_SOURCES = lstextures.cpp texturefilenameelement.cpp

# Create Mac OS X application bundles.
app-bundles: all-am
	@case $(target_os) in darwin* ) \
	  for i in $(noinst_PROGRAMS); do \
	    if test -f $$i; then $(soguiconfig) --build-app $$i; fi \
	  done;; \
	esac