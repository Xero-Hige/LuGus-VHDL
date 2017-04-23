FROM pypi/vunit_hdl:latest

MAINTAINER Xero-Hige <Gaston.martinez.90@gmail.com>
WORKDIR /

RUN apt-get update && \
    apt-get install -y --no-install-recommends aptitude && \
    aptitude install -y \
        wget \
        locales \
        python3-pip \
		python3-setuptools && \
    rm -rf /var/lib/apt/lists/* && \
    aptitude clean

RUN pip3 install vunit --no-cache-dir

COPY /TP3 /LuGus

WORKDIR /LuGus

CMD ["bash","run.sh"]
