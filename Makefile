BINARY_NAME = play-sudoku
BINARY_PATH = ./$(BINARY_NAME)

BINARY_ENTRY_POINT = main

DEPENDS.main = generator checker draw terminal input cmd-params
DEPENDS.cmd-params = version
DEPENDS.generator = helpers cmd-params
DEPENDS.draw = terminal

mk-uniq = $(if $(1),$(firstword $(1)) $(call mk-uniq,$(filter-out $(firstword $(1)),$(1))))
mk-include-order = $(call mk-uniq,$(foreach d,$(DEPENDS.$(1)),$(call mk-include-order,$(d))) $(1))

INCLUDE_ORDER := $(call mk-include-order,$(BINARY_ENTRY_POINT))
ALL_SCRIPTS := $(addsuffix .sh,$(INCLUDE_ORDER))

PREFIX := /usr/bin
BINARY_INSTALL_PATH := $(PREFIX)/$(BINARY_NAME)

.PHONY: all install clean install-clean

all: $(BINARY_PATH)
install: all $(BINARY_INSTALL_PATH)

$(BINARY_PATH): $(ALL_SCRIPTS)
	echo '#!/bin/bash --' >$@.tmp
	echo >>$@.tmp
	for script in $^; do \
		echo "########## $$script ##########" >>$@.tmp; \
		echo >> $@.tmp; \
		cat $$script >>$@.tmp; \
		echo >> $@.tmp; \
	done
	mv $@.tmp $@
	chmod a+x $@

$(BINARY_INSTALL_PATH): $(BINARY_PATH)
	mkdir -p $(@D)
	install -m 755 $< $@

clean:
	rm -rf $(BINARY_PATH)

install-clean: clean
	rm -rf $(BINARY_INSTALL_PATH)
