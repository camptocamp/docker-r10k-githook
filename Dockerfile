FROM camptocamp/r10k:2.0.3-5

MAINTAINER mickael.canevet@camptocamp.com

RUN apt-get update \
  && apt-get install -y openssh-server netcat \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN mkdir /srv/puppetmaster.git \
  && chown -R r10k:r10k /srv/puppetmaster.git \
  && su - r10k -s /bin/bash -c "cd /srv/puppetmaster.git && git --bare init"
ADD post-receive /srv/puppetmaster.git/hooks/post-receive

RUN usermod -s /usr/bin/git-shell r10k

VOLUME ["/srv/puppetmaster.git"]

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
