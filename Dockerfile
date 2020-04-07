FROM ubuntu:xenial

COPY .student-dist /usr/class/cs143

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-i386 flex bison build-essential wget csh \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/ln -s/cp -r -L/g' /usr/class/cs143/assignments/*/Makefile \
    && ln -s /usr/class/cs143 /root/cs143

RUN wget -qO- https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install adopt@1.8.0-242 -o /jdk" bash

ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH /usr/class/cs143/bin:$PATH

WORKDIR /usr/class/cs143/assignments
ENTRYPOINT ["/bin/bash"]
