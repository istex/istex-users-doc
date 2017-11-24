.PHONY: doc serve
SHELL:=/bin/bash

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

doc: ## build the doc in public/documentation/
	@./bin/makedoc;

serve: ## serve the doc on a quick web server listening on http://127.0.0.1:8000
	@./bin/makeserve;
