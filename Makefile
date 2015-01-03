#REPORTER = nyan
REPORTER = spec

test:
	./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		--no-exit \
		--inline-diffs

test-w:
	./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		--watch \
		--no-exit \
		--inline-diffs

.PHONY: test test-w
