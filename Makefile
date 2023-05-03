TEX = $(wildcard */*.tex */*/*.tex)
OUT = $(patsubst %/main.tex,build/%/index.html,$(TEX))

all: $(OUT)

clean:
	rm -rf build

build/%/index.html: %/main.tex
	mkdir -p $(dir $@)
	pandoc \
		--standalone --embed-resources --mathml \
		--resource-path=$(dir $<) \
		--metadata title=$(dir $<) \
		$< -o $@
