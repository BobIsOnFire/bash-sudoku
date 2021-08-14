BINARY_NAME = sudoku
BINARY_PATH = ./$(BINARY_NAME)

BINARY_ENTRY_POINT = main

DEPENDS.main = generator checker draw terminal input
DEPENDS.generator = helpers
DEPENDS.draw = terminal

mk-uniq = $(if $(1),$(firstword $(1)) $(call mk-uniq,$(filter-out $(firstword $(1)),$(1))))
mk-include-order = $(call mk-uniq,$(foreach d,$(DEPENDS.$(1)),$(call mk-include-order,$(d))) $(1))

INCLUDE_ORDER := $(call mk-include-order,$(BINARY_ENTRY_POINT))
ALL_SCRIPTS := $(addsuffix .sh,$(INCLUDE_ORDER))

PREFIX := /usr/bin
BINARY_INSTALL_PATH := $(PREFIX)/$(BINARY_NAME)

.PHONY: all install

all: $(BINARY_PATH)

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

install: all
	mkdir -p $(PREFIX)
	install -m 755 $(BINARY_PATH) $(BINARY_INSTALL_PATH)
