TEX = $(wildcard */*.tex */*/*.tex)
OUT = $(patsubst %.tex,build/%.html,$(TEX))

all: $(OUT)

clean:
	rm -rf build

build/%.html: %.tex
	mkdir -p $$(dirname $@)
	pandoc \
		--standalone --embed-resources --mathml \
		--resource-path=$$(dirname $<) \
		--metadata title=$$(dirname $<) \
		$< -o $@
