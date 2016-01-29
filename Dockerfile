FROM camptocamp/puppetserver:2.1.1-9

MAINTAINER mickael.canevet@camptocamp.com

ENV R10K_VERSION='2.0.3'

RUN mkdir -p /opt/puppetlabs/r10k/cache \
  && useradd -r -d /opt/puppetlabs/r10k -s /bin/false r10k \
  && chown r10k:r10k -R /opt/puppetlabs/r10k \
  && chown r10k:r10k -R /etc/puppetlabs/code/environments

RUN gem install r10k --version $R10K_VERSION --no-ri --no-rdoc

RUN apt-get update \
  && apt-get install -y openssh-server \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN mkdir /srv/puppetmaster.git \
  && chown -R r10k:r10k /srv/puppetmaster.git \
  && su - r10k -s /bin/bash -c "cd /srv/puppetmaster.git && git --bare init"
ADD post-receive /srv/puppetmaster.git/hooks/post-receive

RUN usermod -s /usr/bin/git-shell r10k

VOLUME ["/srv/puppetmaster.git", "/opt/puppetlabs/r10k/cache/"]

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
