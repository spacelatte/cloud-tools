
FROM debian:testing

RUN apt update
RUN apt install -y --no-install-recommends \
	ca-certificates \
	curl \
	file \
	gcc \
	git \
	jq \
	make \
	media-types \
	mime-support \
	shared-mime-info \
	unzip \
	xz-utils \
	;

WORKDIR /home
COPY makefile ./

ENTRYPOINT [ "make" ]
CMD [ ]
