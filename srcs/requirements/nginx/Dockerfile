FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends nginx openssl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/sites-available/default
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN mkdir -p /etx/nginx/sll

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]