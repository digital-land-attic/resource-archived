.PHONY: init render

init:
	git submodule update --init --recursive --remote
	cd brownfield-resources && python3 -m pip install -r requirements.txt

render:
	mkdir -p docs
	cd brownfield-resources && \
		mkdir -p tmp/log && \
		python3 resource_generator/view_data_page.py --all
	rsync -a ./brownfield-resources/tmp/resource/ ./docs/

clean::
	rm -rf docs

