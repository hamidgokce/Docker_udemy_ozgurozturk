# FROM ubuntu:latest
# WORKDIR /gecici
# # ADD https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz .
# ADD https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz .
# CMD ls -al

FROM ubuntu:latest
WORKDIR /gecici
ARG VERSION
ADD https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz .
CMD ls -al