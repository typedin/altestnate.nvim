.PHONY: test lint 

test:
	@NVIM_APPNAME=nvim-test nvim --headless --noplugin --clean -u scripts/minimal_init.lua \
		-c "lua require('plenary.test_harness').test_directory('tests', {minimal_init='scripts/minimal_init.lua'})" -c "q"

lint:
	@luacheck lua/altestnate


