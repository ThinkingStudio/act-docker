#!/bin/bash

for i in "$@"
do
case $i in
    -r=*|--repo=*)
    REPO="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--path=*)
    PROJECTPATH="${i#*=}"
    shift # past argument=value
    ;;
    --production)
    PROD=YES
    shift # past argument with no value
    ;;
    --clean)
    CLEAN=YES
    shift # past argument with no value
    ;;
    --noup)
    NOUP=YES
    shift # past argument with no value
    ;;
    --nobuild)
    NOBUILD=YES
    shift # past argument with no value
    ;;
  
    -?|--help)
        echo "Act.Framework Docker Deploy"
        echo "-r or --repo to specify full URL to repo to clone"
        echo "example -r=https://github.com/actframework/act-demo-apps.git"
        echo ""
        echo "-p or --path to specify the path inside the repo to the root of the Act.Framework project"
        echo "example -p=helloworld"
        echo "leave unset or use . for root path"
        echo ""
        echo "--production to set the prod flag"
        echo "this will deploy the application to docker container and use prod configuration"
        echo "todo: this version still uses maven on prod server to build/deploy"
        echo ""
        echo "--clean to force all containers to recreate"
        echo ""
        echo "--noup to build the docker container only"
        echo ""
        echo "--nobuild to deploy the docker container only"
        echo ""

        echo "-? or --help ... well, you know what that command does now. You're reading it."
        exit
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

echo "Checking out repo..."
rm -rf temp
mkdir temp
git clone ${REPO} temp


echo "Setting up and copying configuration files..."
if [[ "${PROD}" != 'YES' ]]; 
    then
        TARGET=dev
    else
        TARGET=prod
fi

if [[ "${PROJECTPATH}" == '' ]]; 
    then
        PROJECTPATH='.'
fi

sed "s/STATE/${TARGET}/" rsrc/Dockerfile_template >temp/${PROJECTPATH}/Dockerfile
cp rsrc/docker-compose.yml temp/${PROJECTPATH}/docker-compose.yml

#remove default startup scripts
rm temp/${PROJECTPATH}/run_dev
rm temp/${PROJECTPATH}/run_prod
#replace with Docker specific
cp rsrc/run_dev temp/${PROJECTPATH}/
cp rsrc/run_prod temp/${PROJECTPATH}/
cp rsrc/build_dev temp/${PROJECTPATH}/
cp rsrc/build_prod temp/${PROJECTPATH}/
cp rsrc/service.sh temp/${PROJECTPATH}/
cp rsrc/service-runner.sh temp/${PROJECTPATH}/

#todo: we should copy the standard Node.JS configuration pattern here too! 

echo "Composing and starting container..."
cd temp/${PROJECTPATH}/
if [[ "${NOUP}" == 'YES' ]]; 
    then
        docker-compose build
        exit
fi
if [[ "${NOBUILD}" == 'YES' ]]; 
    then
        docker-compose up -d --no-build
        exit
fi
if [[ "${CLEAN}" == 'YES' ]]; 
    then
        docker-compose up -d --build --force-recreate
        exit
fi
docker-compose up -d --build


