.PHONY = install-requirements \
	install-test-requirements \
	build-devcontainer \
	test-devcontainer \
	enter-devcontainer

install-requirements:
	./bin/install-requirements

install-test-requirements:
	rm -rf .venv
	./bin/install-test-requirements

build-devcontainer:
	./bin/build-devcontainer

test-devcontainer:
	./bin/install-test-requirements
	./bin/test-devcontainer

enter-devcontainer:
	./bin/enter-devcontainer
