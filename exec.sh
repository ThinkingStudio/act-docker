#!/bin/bash
mkdir actframework
cd actframework
git clone https://github.com/actframework/act-demo-apps.git
cd act-demo-apps
cd helloworld
mvn clean package
cd target/dist
unzip *
chmod 755 ./start
./start


docker-compose up -d --build

