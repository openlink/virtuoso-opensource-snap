SNAP		= snap
SNAPCRAFT	= snapcraft

all:
	$(SNAPCRAFT)

clean:
	$(SNAPCRAFT) clean --step pull scripts

realclean:
	$(SNAPCRAFT) clean


reinstall:
	-sudo $(SNAP) remove virtuoso-opensource
	-sudo $(SNAP) install --devmode *.snap
