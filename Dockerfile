FROM frolvlad/alpine-glibc
MAINTAINER Matt Schreiber <schreibah@gmail.com>

ARG DROPBOX_VERSION
ENV DROPBOX_VERSION "${DROPBOX_VERSION:-43.4.50}"

ADD "https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-${DROPBOX_VERSION}.tar.gz" /tmp/dropbox.tar.gz
ADD "https://www.dropbox.com/download?dl=packages/dropbox.py" /usr/local/bin/dropbox-cli

RUN		apk add -U --no-cache ca-certificates python \
	&&	tar -C /tmp -xvf /tmp/dropbox.tar.gz \
	&&	mkdir /opt \
	&&	mv "/tmp/.dropbox-dist/dropbox-lnx.x86_64-${DROPBOX_VERSION}" /opt/dropbox \
	&&	ln -s /opt/dropbox/dropbox /usr/local/bin/dropbox \
	&&	ln -s /opt/dropbox/dropboxd /usr/local/bin/dropboxd \
	&& 	rm -f /tmp/dropbox.tar.gz \
	&& 	install -dm0 /.dropbox-dist \
	&& 	chmod o-w /tmp \
	&& 	chmod g-w /tmp \
	&& 	chmod 755 /usr/local/bin/dropbox-cli

WORKDIR /Dropbox
EXPOSE 17500
VOLUME ["/.dropbox", "/Dropbox"]
CMD ["/usr/local/bin/dropboxd"]
