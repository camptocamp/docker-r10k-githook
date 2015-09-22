FROM camptocamp/r10k:2.0.3-2

MAINTAINER mickael.canevet@camptocamp.com

RUN apt-get update \
  && apt-get install -y openssh-server \
  && apt-get clean

RUN mkdir /var/run/sshd

RUN mkdir /srv/puppetmaster.git \
  && chown -R puppet:puppet /srv/puppetmaster.git \
  && su - puppet -s /bin/bash -c "cd /srv/puppetmaster.git && git --bare init"
COPY post-receive /srv/puppetmaster.git/hooks/post-receive
RUN chmod +x /srv/puppetmaster.git/hooks/post-receive

RUN usermod -s /usr/bin/git-shell puppet

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
