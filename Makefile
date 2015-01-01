#REPORTER = nyan
REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER)

test-w:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		--watch

.PHONY: test test-w
