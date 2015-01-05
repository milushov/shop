#REPORTER = nyan
REPORTER = spec
#REPORTER = min

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		--no-exit \
		--inline-diffs

test-w:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter $(REPORTER) \
		--watch \
		--no-exit \
		--inline-diffs

nyan-w:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script/register \
		--reporter nyan \
		--watch \
		--no-exit \
		--inline-diffs

install:
	npm install
	bower install
	./node_modules/gulp/bin/gulp.js build
	./node_modules/coffee-script/bin/coffee seed.coffee
	./node_modules/coffee-script/bin/coffee build_dictionary.coffee
	./node_modules/coffee-script/bin/coffee app/app.coffee

.PHONY: test test-w nyan-w
