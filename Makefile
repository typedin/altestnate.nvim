.PHONY: tests lint 

tests:
	@for test_file in $$(find tests -name "*_spec.lua"); do \
    NVIM_APPNAME=nvim-test nvim --headless --noplugin --clean -u scripts/minimal_init.lua \
    -c "lua require('plenary.test_harness').test_directory('$$test_file', {minimal_init='scripts/minimal_init.lua', timeout=1000})" -c "q"; \
  done
  
lint:
	@luacheck lua/altestnate
