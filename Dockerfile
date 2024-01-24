FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home
RUN apt-get update 
RUN apt-get install -y pandoc pdftk 
RUN apt-get install -y texlive-latex-extra texlive-fonts-recommended
RUN 
COPY md2pdf /opt/md2pdf
WORKDIR /md2docs
ENTRYPOINT [ "/opt/md2pdf" ]