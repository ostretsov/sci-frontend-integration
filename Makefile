.PHONY: build
build:
	make npm-compile-docker-image

	make clean

	make install-and-build-npm-deps
	make install-bower-deps

	make build-layout

	make copy-js

DOCKER_IMAGE := $(shell echo `pwd`| sed 's/[^a-zA-Z]/_/g' | sed 's/^.//')
.PHONY: npm-compile-docker-image
npm-compile-docker-image:
	docker build -t $(DOCKER_IMAGE) .

#
#   Two versions are used because debian one asks for pass phrase while authorizing.
#

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
        mkenney/npm:latest $(EXEC) $(CMD)

.PHONY: npm-compile
npm-compile:
	docker run \
        --rm \
        -it \
        -v $(SRC):/src:rw -v ~/.ssh:/home/dev/.ssh \
        -e "PUID=$(shell id -u)" \
        -e "PGID=$(shell id -g)" \
        $(DOCKER_IMAGE) $(EXEC) $(CMD)

.PHONY: clean
clean:
	rm -rf web/js node_modules bower/bower_components *.log tmp/*

.PHONY: install-npm-deps
install-and-build-npm-deps:
	make npm CMD=install
	cp node_modules/sci-frontend/src/assets/js/integration.js tmp/integration.js
	make npm CMD="run build"

.PHONY: install-bower-deps
install-bower-deps:
	make npm EXEC=bower SRC="`pwd`/bower" CMD=install

.PHONY: build-layout
build-layout:
	make npm SRC="`pwd`/node_modules/sci-layout3" CMD=install
	make npm-compile EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/optipng-bin/lib/install.js"
	make npm-compile EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/gifsicle/lib/install.js"
	make npm-compile EXEC=node SRC="`pwd`/node_modules/sci-layout3" CMD="node_modules/pngquant-bin/lib/install.js"
	make npm-compile EXEC=gulp SRC="`pwd`/node_modules/sci-layout3" CMD=prod

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
	cp node_modules/sci-layout3/prod/js/testing-page.btn-appear.js web/js/layout3-testing-page-btn-appear.js
	cp node_modules/sci-layout3/prod/js/ep-builder.add-event.js web/js/layout3-ep-builder.add-event.js
	cp node_modules/sci-layout3/prod/js/ep-builder.important.js web/js/layout3-ep-builder.important.js
	cp node_modules/sci-layout3/prod/js/ep-builder.speaker.js web/js/layout3-ep-builder.speaker.js
	cp node_modules/sci-layout3/prod/js/inner-modals.js web/js/layout3-inner-modals.js
	cp node_modules/sci-layout3/prod/js/masonry.event-pins.js web/js/layout3-masonry.event-pins.js
	cp node_modules/sci-layout3/prod/js/panel-toggle.js web/js/layout3-panel-toggle.js
	cp node_modules/sci-layout3/prod/js/filter-toggle.js web/js/layout3-filter-toggle.js
	cp node_modules/sci-layout3/prod/js/options-tree.open.js web/js/layout3-options-tree.open.js
	cp node_modules/sci-layout3/prod/js/carousel.universiade.js web/js/layout3-carousel.universiade.js
	cp node_modules/sci-layout3/prod/js/carousel.img-aligner.js web/js/layout3-carousel.img-aligner.js
	cp node_modules/sci-layout3/prod/js/carousel.index.js web/js/layout3-carousel.index.js
	cp node_modules/sci-layout3/prod/js/index-scrollTo.js web/js/layout3-index-scrollTo.js

	cp node_modules/sci-interests/build/js/interest.js web/js/sci-interest.js
	cp node_modules/sci-interests/build/js/templates.js web/js/sci-interest-templates.js
	cp bower/bower_components/sci-location/build/js/location.js web/js/sci-location.js
	cp bower/bower_components/sci-location/build/js/templates.js web/js/sci-location-templates.js
	cp bower/bower_components/sci-organization/build/js/organization.js web/js/sci-organization.js
	cp bower/bower_components/sci-organization/build/js/templates.js web/js/sci-organization-templates.js
	cp bower/bower_components/sci-user/build/js/user.js web/js/sci-user.js
	cp bower/bower_components/sci-user/build/js/templates.js web/js/sci-user-templates.js

	cp bower/bower_components/plupload/js/plupload.full.min.js web/js/plupload.js
	cp bower/bower_components/tinymce/tinymce.min.js web/js/tinymce.min.js
	cp bower/bower_components/jquery-waypoints/waypoints.js web/js/waypoints.js
	cp bower/bower_components/ace-builds/src-noconflict/ace.js web/js/ace.js
	cp bower/bower_components/masonry/dist/masonry.pkgd.js web/js/masonry.js
	cp bower/bower_components/imgLiquid/js/imgLiquid.js web/js/img-liquid.js
	cp node_modules/quill/quill.js web/js/quill.js
	cp node_modules/mathjax/MathJax.js web/js/mathjax.js
	cp node_modules/mathjax/config/TeX-AMS-MML_HTMLorMML.js web/js/mathjax-config-TeX-AMS-MML_HTMLorMML.js
	cp node_modules/sci-layout3/source/js/global/owl.carousel.js web/js/owl.carousel.js
	cp node_modules/cropper/dist/cropper.js web/js/cropper.js
