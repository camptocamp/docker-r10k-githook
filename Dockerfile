FROM camptocamp/puppetserver:2.7.2-5

ENV R10K_VERSION='2.5.2' \
    GOVERSION="1.7.5" \
    GOPATH="/go" \
    GOROOT="/goroot"

RUN mkdir -p /opt/puppetlabs/r10k/cache \
  && mkdir -p /opt/puppetlabs/r10k/.ssh \
  && useradd -r -d /opt/puppetlabs/r10k -s /usr/bin/git-shell r10k \
  && chown -R r10k. /opt/puppetlabs/r10k

RUN gem install r10k --version $R10K_VERSION --no-ri --no-rdoc

# github_pki
RUN apt-get update \
  && apt-get -y install git curl \
  && apt-get install -y ca-certificates \
  && curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | tar xzf - \
  && mv /go ${GOROOT} \
  && ${GOROOT}/bin/go get github.com/camptocamp/github_pki \
  && apt-get purge -y --auto-remove git curl \
  && rm -rf go${GOVERSION}.linux-amd64.tar.gz ${GOROOT} \
  && apt-get clean

RUN apt-get update \
  && apt-get install -y openssh-server \
  && rm -f /etc/ssh/ssh_host_*_key* \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's@/etc/ssh/ssh_host@/etc/ssh/ssh_host_keys/ssh_host@g' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd /etc/ssh/ssh_host_keys

RUN mkdir /srv/puppetmaster.git

COPY r10k.yaml /etc/puppetlabs/r10k/
COPY post-receive /

VOLUME ["/srv/puppetmaster.git", "/opt/puppetlabs/r10k/cache/", "/etc/puppetlabs/code/environments", "/etc/ssh/ssh_host_keys"]

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
