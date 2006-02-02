# FIXME: there are more subdirs to build, which we now
# just ignore. 20021220 mortene.

SUBDIRS = 02.Nodes 03.Fields 04.Actions 05.Elements 07.Nodekits

app-bundles:
	@case $(target_os) in darwin* ) \
	  echo "Making Mac OS X application bundles in Toolmaker."; \
	  for dir in $(SUBDIRS); do \ 
	    (cd $$dir; $(MAKE) app-bundles;) \
	  done ;; \
	esac

############################################################################
