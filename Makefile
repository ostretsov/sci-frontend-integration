.PHONY: build
build:
	make docker-image

	make clean

	make install-npm-deps
	make install-bower-deps

	make build-layout

	make copy-js

DOCKER_IMAGE := $(shell echo `pwd`| sed 's/[^a-zA-Z]/_/g' | sed 's/^.//')
.PHONY: docker-image
docker-image:
	docker build -t $(DOCKER_IMAGE) .

SRC := $(shell pwd)
EXEC := npm
.PHONY: npm
npm:
	docker run \
        --rm \
        -it \
        -v $(SRC):/src:rw -v ~/.ssh:/home/dev/.ssh \
        -e "PUID=$(shell id -u)" \
        -e "PGID=$(shell id -g)" \
        $(DOCKER_IMAGE) $(EXEC) $(CMD)

.PHONY: clean
clean:
	rm -rf web/js node_modules bower/bower_components *.log

.PHONY: install-npm-deps
install-npm-deps:
	make npm CMD=install
	make npm CMD="run build"

.PHONY: install-bower-deps
install-bower-deps:
	make npm EXEC=bower SRC="`pwd`/bower" CMD=install

.PHONY: build-layout
build-layout:
	make npm SRC="`pwd`/node_modules/sci-layout3" CMD=install
	make npm EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/optipng-bin/lib/install.js"
	make npm EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/gifsicle/lib/install.js"
	make npm EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/pngquant-bin/lib/install.js"
	make npm EXEC=gulp SRC="`pwd`/node_modules/sci-layout3" CMD=prod

.PHONY: copy-js
copy-js:
	rm -rf web/js
	mkdir -p web/js

	cp bower/bower_components/angular/angular.js web/js
	cp bower/bower_components/bootstrap/dist/js/bootstrap.js web/js
	cp bower/bower_components/eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js web/js/bootstrap-datetimepicker.js
	cp bower/bower_components/angular-bootstrap/ui-bootstrap-tpls.js web/js/angular-bootstrap-tpls.js
	cp bower/bower_components/angular-sanitize/angular-sanitize.js web/js
	cp bower/bower_components/angular-ui-sortable/sortable.js web/js/angular-ui-sortable.js
	cp node_modules/jquery/dist/jquery.js web/js
	cp bower/bower_components/jquery-ui/jquery-ui.js web/js
	cp bower/bower_components/lodash/lodash.js web/js
	cp bower/bower_components/moment/min/moment-with-locales.js web/js

	cp node_modules/sci-layout3/prod/js/lib/delete-confirm.js web/js/layout3-delete-confirm.js
	cp node_modules/sci-layout3/prod/js/lib/delete-file.js web/js/layout3-delete-file.js
	cp node_modules/sci-layout3/prod/js/lib/my-datepicker.js web/js/layout3-my-datepicker.js
	cp node_modules/sci-layout3/prod/js/lib/svg.js web/js/layout3-svg.js
	cp node_modules/sci-layout3/prod/js/lib/tooltips.js web/js/layout3-tooltips.js
	cp node_modules/sci-layout3/prod/js/lib/video.js web/js/layout3-video.js
	cp node_modules/sci-layout3/prod/js/lib/initneedfulthings.js web/js/layout3-initneedfulthings.js
	cp node_modules/sci-layout3/prod/js/lib/blockheader.js web/js/layout3-blockheader.js
	cp node_modules/sci-layout3/prod/js/lib/menus.js web/js/layout3-menus.js
	cp node_modules/sci-layout3/prod/js/check-table.js web/js/layout3-check-table.js
	cp node_modules/sci-layout3/prod/js/options-tree.js web/js/layout3-options-tree.js
