TEX_SRC := $(wildcard */*.tex */*/*.tex)
TEX_OUT := $(patsubst %/main.tex,build/%/index.html,$(TEX_SRC))

# Kind of hacky stuff to generate Markdown to index all built cheatsheets.
MD_DIRS := $(dir $(TEX_OUT))
MD_NAMES := $(patsubst build/%,[%],$(MD_DIRS))
MD_LINKS := $(patsubst build/%,(%)\n\n,$(TEX_OUT))
MD := $(join $(MD_NAMES),$(MD_LINKS))

all: build/index.html

.PHONY: clean
clean:
	rm -rf build

build/%/index.html: %/main.tex
	mkdir -p $(dir $@)
	pandoc \
		--standalone --embed-resources --mathml \
		--resource-path=$(dir $<) \
		--metadata title=$(dir $<) \
		$< -o $@

build/index.md: $(TEX_OUT)
	printf '$(MD)' > $@

build/index.html: build/index.md
	pandoc --standalone --metadata title=Cheatsheets $< -o $@
