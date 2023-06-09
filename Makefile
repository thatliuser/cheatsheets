SRC := $(wildcard */*.tex */*/*.tex)
HTML_OUT := $(patsubst %/main.tex,build/%/index.html,$(SRC))
PDF_OUT := $(patsubst %.tex,build/%.pdf,$(SRC))

# Kind of hacky stuff to generate Markdown to index all built cheatsheets.
MD_NAMES := $(patsubst build/%,[%],$(dir $(HTML_OUT)))
MD_SITES := $(patsubst build/%,(%),$(HTML_OUT))
MD_PDFS := $(patsubst build/%,\t<sub>[(pdf)](%)</sub>\n\n,$(PDF_OUT))
MD := $(join $(join $(MD_NAMES),$(MD_SITES)),$(MD_PDFS))

.PHONY: all html pdf clean
all: html pdf

html: build/index.html

pdf: $(PDF_OUT)

clean:
	rm -rf build

build/%/index.html: %/main.tex
	mkdir -p $(dir $@)
	pandoc \
		--standalone --embed-resources --mathml \
		--resource-path=$(dir $<) \
		--metadata title=$(dir $<) \
		$< -o $@

build/index.md: $(HTML_OUT) $(PDF_OUT)
	printf '$(MD)' > $@

build/index.html: build/index.md
	pandoc --standalone --metadata title=Cheatsheets $< -o $@

build/%.pdf: %.tex
	mkdir -p $(dir $@)
	tectonic $< -o $(dir $@)
