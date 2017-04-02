FROM openjdk:8
RUN apt-get update && apt-get -y install maven && apt-get -y install unzip
ADD . /usr/local/act
RUN cd /usr/local/act/helloworld && mvn clean compile && chmod 755 run_dev
CMD [""]
ENTRYPOINT ["/usr/local/act/helloworld/run_dev"]
