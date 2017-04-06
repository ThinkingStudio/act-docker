# Act.Framework Dcoker Deploy Tool

This is the experimental scripts for Act.Framework Docker

Create a new directory, copy or clone in the exec.sh and /rsrc directory and then call exec.sh as follows:

-r or --repo to specify full URL to repo to clone
example -r=https://github.com/actframework/act-demo-apps.git

-p or --path to specify the path inside the repo to the root of the Act.Framework project
example -p=helloworld
leave unset or use . for root path

--production to set the prod flag
this will deploy the application to docker container and use prod configuration
todo: this version still uses maven on prod server to build/deploy
this will embed the application as a service so that you can 'up' services or restart them and the service will start as part of the linux startup sequence

--clean to force all containers to recreate and redelpoy

--noup to build the docker container only without deployment

--nobuild to deploy the current docker container only

-? or --help for... 

