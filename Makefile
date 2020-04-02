.PHONY: init render

init:
	git submodule update --init --recursive --remote
	cd brownfield-resources && python3 -m pip install -r requirements.txt

render:
	cd brownfield-resources && \
		mkdir -p tmp/log && \
		python3 resource_generator/check_data_page.py --all && \
		python3 resource_generator/index.py && \
		python3 resource_generator/report_page.py && \
		python3 resource_generator/daily_summary_page.py && \
		python3 resource_generator/cli.py --input-dir ../brownfield-land-collection/validation
	rsync -a ./brownfield-resources/tmp/resource/ ./docs/
	rsync -a ./brownfield-resources/tmp/log/ ./docs/log/
	mv ./brownfield-resources/tmp/index.html ./docs/index.html
	mv ./brownfield-resources/tmp/report.html ./docs/report.html
