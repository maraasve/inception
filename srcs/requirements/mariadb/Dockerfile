FROM debian:bookworm

# rm -rf /var/lib/apt/lists/*	->	remove package repository metadata
# apt-get clean	->	remove installation files
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]