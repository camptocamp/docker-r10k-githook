FROM camptocamp/puppetserver:2.2.1-5

MAINTAINER mickael.canevet@camptocamp.com

ENV R10K_VERSION='2.0.3'

RUN mkdir -p /opt/puppetlabs/r10k/cache \
  && useradd -r -d /opt/puppetlabs/r10k -s /usr/bin/git-shell r10k

RUN gem install r10k --version $R10K_VERSION --no-ri --no-rdoc
RUN gem install rack --no-ri --no-rdoc
RUN gem install github_api --no-ri --no-rdoc

RUN apt-get update \
  && apt-get install -y openssh-server \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN mkdir /srv/puppetmaster.git

COPY post-receive /

VOLUME ["/srv/puppetmaster.git", "/opt/puppetlabs/r10k/cache/"]

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
