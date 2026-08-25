FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		php-fpm \
		php-mysql \
		php-curl \
		php-gd \
		php-mbstring \
		php-xml \
		php-zip \
		wget \
		curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
	tar -xzf /tmp/wordpress.tar.gz -C /tmp && \
	cp -r /tmp/wordpress/* /var/www/html/ && \
	rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

CMD ["usr/local/bin/setup.sh"]