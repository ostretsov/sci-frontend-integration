# node 7.7 builds seamlessly
FROM mkenney/npm:node-7-debian

# for optipng (layout3)
RUN apt-get update
RUN apt-get install -y \
        automake \
		git \
		nasm  \
		autoconf  \
		zlib1g \
		zlib1g-dev \
		zlibc \
		libghc-zlib-dev \
		libpng12-0 \
		libpng12-dev\
		libpng++-dev\
		libwebp2 \
		libwebp-dev \
		libjpeg62 \
		libjpeg8 \
        libjpeg8-dev