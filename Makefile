.PHONY: init render

# current git branch
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

render:
	mkdir -p docs
	cd brownfield-resources && \
		mkdir -p tmp/log && \
		python3 resource_generator/view_data_page.py --all
	rsync -a ./brownfield-resources/tmp/resource/ ./docs/

init:
	git submodule update --init --recursive --remote
	cd brownfield-resources && python3 -m pip install -r requirements.txt

clean::
	rm -rf docs

commit-docs::
	git add docs organisation-dataset brownfield-resources
	git diff --quiet && git diff --staged --quiet || (git commit -m "Rebuilt docs $(shell date +%F)"; git push origin $(BRANCH))

