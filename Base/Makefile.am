## Process this file with automake to generate Makefile.in.

SUBDIRS = elements

app-bundles:
	@case $(target_os) in darwin* ) \
	  echo "Making Mac OS X application bundles in Base."; \
	  for dir in $(SUBDIRS); do \ 
	    (cd $$dir; $(MAKE) app-bundles;) \
	  done ;; \
	esac