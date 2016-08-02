FROM alpine:3.4

RUN apk add --no-cache \
    ca-certificates \
    curl            \
    bash            \
    openssl         \
    git             \
    openjdk7-jre    \
    openssh         \
    openssh-client

ENV DOCKER_VERSION 1.12.0
ENV DOCKER_URL http://experimental.docker.com.s3.amazonaws.com/builds/Linux/x86_64/docker-1.12.0.tgz
ENV DOCKER_SHA256 04fbc9ee331c8bafadd02bb8065c4e0e713fa2747f070f77c0b630db1da18e10

RUN set -x \
  && curl -fSL "${DOCKER_URL}" -o docker.tgz \
  && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
  && tar -xzvf docker.tgz \
  && mv docker/* /usr/local/bin/ \
  && rmdir docker \
  && rm docker.tgz \
  && docker -v

COPY docker-entrypoint.sh /usr/local/bin/

#ENTRYPOINT ["docker-entrypoint.sh"]
#CMD ["bash"]
RUN ssh-keygen -A
RUN echo 'root:docker' | chpasswd

# let's make /root a volume so ~/.ssh/authorized_keys is easier to save
VOLUME /root

EXPOSE 22
COPY start_sshD.sh /
ENTRYPOINT ["/start_sshD.sh"]
CMD []
