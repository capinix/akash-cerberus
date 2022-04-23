FROM ubuntu:22.04

ENV APP_USER=node

ENV MONIKER_NAME=Radical
ENV CHAIN_ID=cerberus-chain-1

# Set the timezone to UTC
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update the system
RUN apt-get update && apt-get upgrade -y

RUN yes | unminimize

# Install locales
RUN apt-get install -y locales
# generate utf-8
RUN locale-gen en_US.UTF-8

# Install utilities
RUN apt-get install -y bc byobu curl openjdk-8-jdk ssh sudo tmux vim
    
# Add user
RUN useradd -rm -d /home/${APP_USER} -s /bin/bash ${APP_USER}
RUN echo "${APP_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure ssh key auth for root and user
RUN mkdir /root/.ssh /home/${APP_USER}/.ssh && chmod 700 /root/.ssh /home/${APP_USER}/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys
COPY id_rsa.pub /home/${APP_USER}/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys /home/${APP_USER}/.ssh/authorized_keys
RUN chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}/.ssh

# start ssh server
RUN mkdir -p /var/run/sshd
CMD [ "/usr/sbin/sshd", "-D" ]

RUN apt-get install make build-essential gcc git jq chrony golang -y

RUN cd /opt && \
    git clone https://github.com/cerberus-zone/cerberus.git && \
	cd cerberus && \
	git fetch -a && \
	git checkout v1.0.1 && \
	make install && \
	cp bin/cerberusd /usr/local/bin

RUN su ${APP_USER} -c "cerberusd init ${MONIKER_NAME} --chain-id ${CHAIN_ID}"    
COPY config/* /home/${APP_USER}/.cerberus/config/
RUN chown ${APP_USER}:${APP_USER} /home/${APP_USER}/.cerberus/config/*
COPY sh/* /home/${APP_USER}/
RUN chown ${APP_USER}:${APP_USER} /home/${APP_USER}/*.sh
RUN chmod 755 /home/${APP_USER}/*.sh
RUN su ${APP_USER} -l ./node.sh
RUN su ${APP_USER} -l ./state_sync.sh
RUN su ${APP_USER} -lP ./tmux.sh
