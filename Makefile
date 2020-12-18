.PHONY: init render

init:
	git submodule update --init --recursive --remote
	cd brownfield-resources && python3 -m pip install -r requirements.txt

render:
	cd brownfield-resources && \
		mkdir -p tmp/log && \
		python3 resource_generator/view_data_page.py --all
	rsync -a ./brownfield-resources/tmp/resource/ ./docs/


render-original:
	cd brownfield-resources && \
		mkdir -p tmp/log && \
		python3 resource_generator/view_data_page.py --all && \
		python3 resource_generator/report_page.py && \
		python3 resource_generator/daily_summary_page.py && \
		python3 resource_generator/cli.py --input-dir ../brownfield-land-collection/validation
	rsync -a ./brownfield-resources/tmp/resource/ ./docs/
	rsync -a ./brownfield-resources/tmp/log/ ./docs/log/
	mv ./brownfield-resources/tmp/report.html ./docs/report.html
