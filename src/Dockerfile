FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get dist-upgrade && apt-get -y install python3 python3-pip texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra latexmk
COPY requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt
VOLUME /tmp/src
WORKDIR /tmp/src
CMD make -C b3 html latexpdf
