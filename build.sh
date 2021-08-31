#!/usr/bin/env bash
# © Copyright IBM Corporation 2020, 2021.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
#
# Instructions:
# Download build script: wget https://raw.githubusercontent.com/linux-on-ibm-z/scripts/master/Docker/build_docker.sh
# You need a docker service running on your host before executing the script.
# Execute build script: bash build_docker.sh    (provide -h for help)
set -e -o pipefail
PACKAGE_NAME="docker"
PACKAGE_VERSION="20.10.8"
CONTAINERD_VERSION="1.4.9"
#Token needed to download daemon.json
TOKEN=""
#Token needed to download docker_verify_static.json
TOKEN1=""
#Token needed to download docker_verify_deb.json
TOKEN2=""
##API KEY from the Service Credentials shared with read-write access. IAM Authentication is used here.
API_KEY=""
##Name of the bucket in IBM Cloud Storage
BUCKET_NAME=""
##Public Endpoint where bucket exists
PUBLIC_ENDPOINT=""
CURDIR="$(pwd)"
FORCE="false"
LOG_FILE="$CURDIR/logs/${PACKAGE_NAME}-${PACKAGE_VERSION}-$(date +"%F-%T").log"
trap cleanup 0 1 2 ERR
#Check if directory exsists
if [ ! -d "$CURDIR/logs" ]; then
        mkdir -p "$CURDIR/logs"
fi
if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"
fi
function checkPrequisites() {
        if command -v "sudo" >/dev/null; then
                printf -- 'Sudo : Yes\n' >>"$LOG_FILE"
        else
                printf -- 'Sudo : No \n' >>"$LOG_FILE"
                printf -- 'You can install the same from installing sudo from repository using apt, yum or zypper based on your distro. \n'
                exit 1
        fi
        if [[ "$FORCE" == "true" ]]; then
                printf -- 'Force attribute provided hence continuing with install without confirmation message\n' |& tee -a "$LOG_FILE"
        else
                # Ask user for prerequisite installation
                printf -- "\nAs part of the installation , dependencies would be installed/upgraded.\n"
                while true; do
                        read -r -p "Do you want to continue (y/n) ? :  " yn
                        case $yn in
                        [Yy]*)
                                printf -- 'User responded with Yes. \n' >>"$LOG_FILE"
                                break
                                ;;
                        [Nn]*) exit ;;
                        *) echo "Please provide confirmation to proceed." ;;
                        esac
                done
        fi
}
function cleanup() {
        if [ -f ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz ]; then
                sudo rm ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz
        fi
}
function configureAndInstall() {
        printf -- 'Configuration and Installation started \n'
       # Download and Install Go
        cd /"$CURDIR"/
        #wget https://raw.githubusercontent.com/linux-on-ibm-z/scripts/master/Go/1.15/build_go.sh
        #bash build_go.sh -y
        DISTRO=(bionic focal groovy hirsute)
        mkdir -p $CURDIR/go/src/github.com/docker
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/ubuntu-debs
        #mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static


        for DISTRO in "${DISTRO[@]}"
            do
                  if [ -d ""$CURDIR"/go/src/github.com/docker/docker-ce-packaging" ]; then
                    echo "Removing the dir."
                    sudo rm -rf $CURDIR/go/src/github.com/docker/docker-ce-packaging
                  else
                    echo "$CURDIR/go/src/github.com/docker/docker-ce-packaging does not exist!"
                  fi
                 cd $CURDIR/go/src/github.com/docker
                 git clone --depth 1 -b 20.10 https://github.com/docker/docker-ce-packaging
                 cd docker-ce-packaging/
                 make DOCKER_CLI_REF=v$PACKAGE_VERSION DOCKER_ENGINE_REF=v$PACKAGE_VERSION checkout

                 echo "Building deb for $DISTRO"
                 cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/
                 make clean
                 make REF=v$PACKAGE_VERSION VERSION=$PACKAGE_VERSION RASPBIAN_VERSIONS= UBUNTU_VERSIONS= DEBIAN_VERSIONS=ubuntu-$DISTRO deb
                 mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/ubuntu-debs/ubuntu-$DISTRO
                 cp -rf $CURDIR/go/src/github.com/docker/docker-ce-packaging/deb/debbuild/ubuntu-$DISTRO/* $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/ubuntu-debs/ubuntu-$DISTRO

                 make -C deb VERSION=$PACKAGE_VERSION debbuild/bundles-ce-ubuntu-$DISTRO-s390x.tar.gz
                 mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries-tar/
                 cp deb/debbuild/bundles-ce-ubuntu-$DISTRO-s390x.tar.gz $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries-tar/
            done
        ## Build Containerd binaries
        cd $CURDIR/go/src/github.com/docker
        git clone https://github.com/docker/containerd-packaging
        cd containerd-packaging
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/
        DISTRO=(bionic focal groovy hirsute)
        for DISTRO in "${DISTRO[@]}"
            do
            make REF=v$CONTAINERD_VERSION docker.io/library/ubuntu:$DISTRO
                        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/$DISTRO
                        cp -rf $CURDIR/go/src/github.com/docker/containerd-packaging/build/ubuntu/$DISTRO $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/$DISTRO
            done
        #Building Static Binaries

        #cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/static
        #make REF=v$PACKAGE_VERSION VERSION=$PACKAGE_VERSION static-linux
        #cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/static/build/linux/
        #cp -rf $CURDIR/go/src/github.com/docker/docker-ce-packaging/static/build/linux $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static/
}
function verifyBinaries() {

 printf -- '**************************** Starting Docker with DeviceMapper *************************************************************\n'>"$LOG_FILE"
        sudo systemctl stop docker
        sudo cp /etc/docker/daemon.json  /etc/docker/daemon_old.json
        wget -O daemon.json https://raw.github.ibm.com/loz/opensource-porting-s390x/master/Docker-CE/daemon.json?token=$TOKEN
        cp daemon.json  /etc/docker/daemon.json
        #systemctl daemon-reload && systemctl disable docker.service && systemctl enable docker.service
        #systemctl start docker
        dockerd &
        sleep 60s
        docker info | grep devicemapper
        docker ps -a

 printf -- '**************************** Starting to Verify Binaries *************************************************************\n' >"$LOG_FILE"
 DISTRO=(bionic focal groovy hirsute)
 distros=("rhel" "sles" "ubuntu")
 ubuntu_versions=("18.04" "20.04" "20.10" "21.04")
 rhel_versions=("7.8" "7.9" "8.1" "8.2" "8.3" "8.4")
 sles_versions=("12-sp5" "15-sp2")


echo "Verifying Static Binaries"
 cd $CURDIR
 wget -O docker_verify_static.sh https://raw.github.ibm.com/loz/opensource-porting-s390x/master/Docker-CE/docker_verify_static.sh?token=$TOKEN1
 wget -O docker_verify_deb.sh https://raw.github.ibm.com/loz/opensource-porting-s390x/master/Docker-CE/docker_verify_deb.sh?token=$TOKEN2

 for rhel_versions in "${rhel_versions[@]}"
        do
        echo "Inside $rhel_versions"
        image="ecos0003:5000/jenkins_jnlpslave_rhel:${rhel_versions}"
        echo $image
        docker run --name docker_${rhel_versions} -e BASH_ENV=/home/test/.bashrc --privileged --net=host --add-host="ftp3.linux.ibm.com:9.10.229.75" -td  $image /bin/bash
        docker cp $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static/ docker_${rhel_versions}:/home/test
        docker cp $CURDIR/docker_verify_static.sh docker_${rhel_versions}:/home/test
        docker exec docker_${rhel_versions}  bash /home/test/docker_verify_static.sh
        docker rm -fv docker_${rhel_versions}
        done

  for ubuntu_versions in "${ubuntu_versions[@]}"
        do
        echo "Inside $ubuntu_versions"
        image="ecos0003:5000/jenkins_jnlpslave_ubuntu:${ubuntu_versions}"
        echo $image
        docker run --name docker_${ubuntu_versions} --privileged --net=host -td  ecos0003:5000/jenkins_jnlpslave_ubuntu:${ubuntu_versions} /bin/bash
        docker cp $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static/ docker_${ubuntu_versions}:/home/test
        docker cp $CURDIR/docker_verify_static.sh docker_${ubuntu_versions}:/home/test
        docker exec docker_${ubuntu_versions}  bash /home/test/docker_verify_static.sh
        docker rm -fv docker_${ubuntu_versions}
        done

    for sles_versions in "${sles_versions[@]}"
        do
        echo "Inside $sles_versions"
        image="ecos0003:5000/jenkins_jnlpslave_sles:${sles_versions}"
        echo $image
        docker run --name docker_${sles_versions} --privileged --net=host --add-host=ftp3install.linux.ibm.com:9.10.229.76 -td  ecos0003:5000/jenkins_jnlpslave_sles:${sles_versions} /bin/bash
        docker cp $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static/ docker_${sles_versions}:/home/test
        docker cp $CURDIR/docker_verify_static.sh docker_${sles_versions}:/home/test
        docker exec docker_${sles_versions}  bash /home/test/docker_verify_static.sh
        docker rm -fv docker_${sles_versions}
        done

  echo "Verifying Deb on Ubuntu!!!!"
    for ubuntu_versions in "${ubuntu_versions[@]}"
         do
        echo "Inside $ubuntu_versions"
        image="ecos0003:5000/jenkins_jnlpslave_ubuntu:${ubuntu_versions}"
        echo $image
        docker run --name docker_deb_${ubuntu_versions} --privileged --net=host -td  ecos0003:5000/jenkins_jnlpslave_ubuntu:${ubuntu_versions} /bin/bash
        docker cp $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/ubuntu-debs/ docker_deb_${ubuntu_versions}:/home/test
        docker cp $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/ docker_deb_${ubuntu_versions}:/home/test
        docker cp $CURDIR/docker_verify_deb.sh docker_deb_${ubuntu_versions}:/home/test
        docker exec docker_deb_${ubuntu_versions}  bash /home/test/docker_verify_deb.sh
        docker rm -fv docker_deb_${ubuntu_versions}
        done
}

function uploadBinaries() {
                printf -- '**************************** Starting to Upload Binaries *************************************************************\n' >"$LOG_FILE"
                #Create IAM Token for Authentication
                IAM_CREDS=$(curl -X "POST" "https://iam.cloud.ibm.com/identity/token" -H 'Accept: application/json' -H 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "apikey=$API_KEY" --data-urlencode "response_type=cloud_iam" --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey")
                IAM_TOKEN=$(jq -r '.access_token' <<< ${IAM_CREDS})
                echo $IAM_TOKEN
                ##Uploading Ubuntu debs
                DISTRO=(bionic focal groovy hirsute)
                for DISTRO in "${DISTRO[@]}"
                do
                        echo $DISTRO
                        FILE_PATH=$CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/ubuntu-debs/ubuntu-$DISTRO
                        BINARY_PATH=linux/ubuntu/dists/$DISTRO/stable
                        cd $FILE_PATH
                        shopt -s nullglob
                        for FILE_NAME in *.deb
                        do
                                printf -- " \n Uploading file: %s \n" "$FILE_NAME"
                                FILE_SIZE=$(stat -c%s "$FILE_NAME")
                                printf -- " \n File Size: %s \n" "$FILE_SIZE"
                                curl -X PUT "$PUBLIC_ENDPOINT/$BUCKET_NAME/$BINARY_PATH/$FILE_NAME" -H "x-amz-acl: public-read" -H "Authorization: Bearer $IAM_TOKEN"  -T "$FILE_NAME"
                                CONTENT_LENGTH=$(curl --head "$PUBLIC_ENDPOINT/$BUCKET_NAME/$BINARY_PATH/$FILE_NAME" -H "Authorization: bearer $IAM_TOKEN" | awk '/Content-Length/{print $2}')
                                printf -- " \n Content Length: %s \n" "$CONTENT_LENGTH"
                                printf -- "\n Verifying uploaded file : %s \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                                if echo "$CONTENT_LENGTH" | grep -q "$FILE_SIZE" ; then
                                        printf -- "\n %s : File uploaded successfully \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                                else
                                        printf -- "\n %s : File size does not match. Upload failed or got corrupted. Please check manually \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                                        exit 1 # terminate and indicate error
                                fi
                        done
                        shopt -u nullglob
                done
                ##Uploading Static Binaries
                FILE_PATH=$CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/static/linux/
                BINARY_PATH=linux/static/s390x
                cd $FILE_PATH
                shopt -s nullglob
                for FILE_NAME in *.tgz
                do
                        printf -- " \n Uploading file: %s \n" "$FILE_NAME"
                        FILE_SIZE=$(stat -c%s "$FILE_NAME")
                        printf -- " \n File Size: %s \n" "$FILE_SIZE"
                        curl -X PUT "$PUBLIC_ENDPOINT/$BUCKET_NAME/$BINARY_PATH/$FILE_NAME" -H "x-amz-acl: public-read" -H "Authorization: Bearer $IAM_TOKEN"  -T "$FILE_NAME"
                        CONTENT_LENGTH=$(curl --head "$PUBLIC_ENDPOINT/$BUCKET_NAME/$BINARY_PATH/$FILE_NAME" -H "Authorization: bearer $IAM_TOKEN" | awk '/Content-Length/{print $2}')
                        printf -- " \n Content Length: %s \n" "$CONTENT_LENGTH"
                        printf -- "\n Verifying uploaded file : %s \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                        if echo "$CONTENT_LENGTH" | grep -q "$FILE_SIZE" ; then
                                printf -- "\n %s : File uploaded successfully \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                        else
                                printf -- "\n %s : File size does not match. Upload failed or got corrupted. Please check manually \n" "$FILE_NAME" |& tee -a "$LOG_FILE"
                                exit 1 # terminate and indicate error
                        fi
                done
                shopt -u nullglob
}

function logDetails() {
        printf -- '**************************** SYSTEM DETAILS *************************************************************\n' >"$LOG_FILE"
        if [ -f "/etc/os-release" ]; then
                cat "/etc/os-release" >>"$LOG_FILE"
        fi
        cat /proc/version >>"$LOG_FILE"
        printf -- '*********************************************************************************************************\n' >>"$LOG_FILE"
        printf -- "Detected %s \n" "$PRETTY_NAME"
        printf -- "Request details : PACKAGE NAME= %s , VERSION= %s \n" "$PACKAGE_NAME" "$PACKAGE_VERSION" |& tee -a "$LOG_FILE"
}
# Print the usage message
function printHelp() {
        echo
        echo "Usage: "
        echo "  build_docker.sh [-d debug]  [-y install-without-confirmation] "
        echo
}
while getopts "h?yd" opt; do
        case "$opt" in
        h | \?)
                printHelp
                exit 0
                ;;
        d)
                set -x
                ;;
        y)
                FORCE="true"
                ;;
        esac
done
function gettingStarted() {
        printf -- "*************************************************************************"
        printf -- "\n\nUsage: \n"
        printf -- "  Docker Binaries installed successfully !!!  \n"
        printf -- "\n ***********Binaries will be created in the following folders************* \n "
        printf -- "\n ************************************************************************ \n "
        printf -- "\$CURDIR/docker-20.10.7-binaries/containerd \n"
        printf -- "\$CURDIR/docker-20.10.7-binaries/static \n "
        printf -- "\$CURDIR/docker-20.10.7-binaries/ubuntu-debs/ \n "
        printf -- "\n************************************************************************** \n"
        printf -- "For building containerd binaries you should first have a tagged release on the containerd(https://github.com/containerd/containerd/releases) repository."
        printf -- '\n'
}
###############################################################################################################
logDetails
checkPrequisites #Check Prequisites
DISTRO="$ID-$VERSION_ID"
case "$DISTRO" in
"ubuntu-18.04" | "ubuntu-20.04" | "ubuntu-20.10" | "ubuntu-21.04")
        printf -- "Installing %s %s for %s \n" "$PACKAGE_NAME" "$PACKAGE_VERSION" "$DISTRO" |& tee -a "$LOG_FILE"
        printf -- 'Installing the dependencies for Docker from repository \n' |& tee -a "$LOG_FILE"
        sudo apt-get update -y >/dev/null
        sudo apt-get install -y wget tar make jq docker.io |& tee -a "$LOG_FILE"
        #sudo groupadd docker
        #sudo usermod -aG docker jenkins
        sudo dockerd &
        sudo docker login -u=lozdocker -p loz@docker
        #sudo chmod 666 /var/run/docker.sock
        configureAndInstall |& tee -a "$LOG_FILE"
        #uploadBinaries |& tee -a "$LOG_FILE"
        #verifyBinaries |& tee -a "$LOG_FILE"
        ;;
*)
        printf -- "%s not supported \n" "$DISTRO" |& tee -a "$LOG_FILE"
        exit 1
        ;;
esac
gettingStarted |& tee -a "$LOG_FILE"
