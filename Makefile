LUA = luajit

DIAGRAM_NAMES = marshal-main marshal-resource_orchestrator marshal-scheduler marshal-schedule_generator marshal-schedule_generator_impl upgrade_listener config_listener
DIAGRAMS = $(patsubst %,docs/src/reference-materials/state-machine-diagrams/%.mmd,$(DIAGRAM_NAMES))
DOC_HELPERS = docs/mdbook-ox/target/release/mdbook-ox
RUST_SOURCES = $(shell find docs/mdbook-ox/src/ -name '*.rs')
SOURCES = $(shell find -name '*.yue')
OBJECTS = $(patsubst %.yue,%.lua,$(SOURCES))
BINARIES = bin/ox bin/goo bin/snoop

NODE_FONTNAME = C059
EDGE_FONTNAME = $(NODE_FONTNAME)
GRAPHVIZ_OPTS = -Gfontname="$(NODE_FONTNAME)" -Nfontname="$(NODE_FONTNAME)" -Efontname="$(EDGE_FONTNAME)"

all: $(BINARIES)
.PHONY: all

docs: $(DIAGRAMS) $(DOC_HELPERS)
	mdbook build docs/
.PHONY: doc

docs/src/reference-materials/state-machine-diagrams/%.mmd: $(OBJECTS)
	luajit ox.lua debug mermaid $(patsubst docs/src/reference-materials/state-machine-diagrams/%.mmd,%,$@) >$@

serve-docs: $(DIAGRAMS) $(DOC_HELPERS)
	mdbook serve docs/ --open
.PHONY: serve-doc

docs/mdbook-ox/target/release/mdbook-ox: docs/mdbook-ox/Cargo.toml $(RUST_SOURCES)
	cargo build --release --manifest-path $<

bin/%: bin/%.lua.packed nitro.lua clap.lua spec.lua
# $(LUA) ./nitro.lua $< -o $@
	cp $< $@

bin/%.lua.packed: %.lua $(OBJECTS) moonpack.lua
	$(LUA) ./moonpack.lua $< -o $@
.INTERMEDIATE: bin/%.lua.packed

%.lua: %.yue ylint.yue
	yue --target=5.1 -l -s --path="?.yue" $< -o $@
	@if [ "$<" != "ylint.yue" ]; then yue -e ylint.yue check $<; fi
	@touch $@
.PRECIOUS: %.lua

ox.yue: compat.lua

clean:
	$(RM) $(OBJECTS) startup.lua packed/ox ox.goo $(BINARIES) bin/*
	cargo clean --manifest-path docs/mdbook-ox/Cargo.toml
.PHONY: clean

install: scripts/install $(BINARIES)
	./$<
.PHONY: install

uninstall: scripts/uninstall
	./$<
.PHONY: uninstall

test: test_ox test_ylint
.PHONY: test

test_ox: ox.lua $(OBJECTS)
	@$(LUA) $< test
.PHONY: test_ox

test_ylint: ylint.lua
	@$(LUA) ylint.lua test
.PHONY: test_ylint

ox/version.lua: .version.txt

.version.txt: scripts/version .FORCE
	./$< > $@

.FORCE:
.PHONY: .FORCE

release: bin/ox ./scripts/release bin/snoop
	./scripts/release bin/ox
	./scripts/release bin/snoop
.PHONY: release
