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
		mariadb-client \
		sendmail \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
	tar -xzf /tmp/wordpress.tar.gz -C /tmp && \
	cp -r /tmp/wordpress/* /var/www/html/ && \
	rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]