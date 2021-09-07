#!/usr/bin/env bash
# © Copyright IBM Corporation 2021.
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
PATCH_URL="https://raw.githubusercontent.com/vibhutisawant/taro-ui/next/patch"
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
        #wget https://raw.githubusercontent.com/linux-on-ibm-z/scripts/master/Go/1.16.6/build_go.sh
        #bash build_go.sh -y
		
        mkdir -p $CURDIR/go/src/github.com/docker
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries-tar/
        
        if [ -d ""$CURDIR"/go/src/github.com/docker/docker-ce-packaging" ]; then
           echo "Removing the dir."
           sudo rm -rf $CURDIR/go/src/github.com/docker/docker-ce-packaging
        else
           echo "$CURDIR/go/src/github.com/docker/docker-ce-packaging does not exist!"
        fi
        cd $CURDIR/go/src/github.com/docker
        git clone --depth 1 -b 20.10 https://github.com/docker/docker-ce-packaging
        cd docker-ce-packaging/
                
        #patch to chnge base image in Dockerfile
        curl -o Dockerfile_rhel7.diff $PATCH_URL/Dockerfile_rhel7.diff
        patch --ignore-whitespace rpm/rhel-7/Dockerfile Makefile_rpm_docker-ce-packaging.diff
        make DOCKER_CLI_REF=v$PACKAGE_VERSION DOCKER_ENGINE_REF=v$PACKAGE_VERSION checkout
        
        ## Build Containerd
        cd $CURDIR/go/src/github.com/docker
        git clone https://github.com/docker/containerd-packaging
        cd containerd-packaging
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/
        
        #Build RHEL-7 containerd binaries
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/rhel-7
        curl -o Makefile_containerd-packaging.diff $PATCH_URL/new.diff
        patch --ignore-whitespace Makefile Makefile_containerd-packaging.diff
        
        
        #fix deps installation on rhel 7 and 8 by adding source .bashrc
        curl -o Dockerfile.rpm.diff $PATCH_URL/rpm.dockerfile_rhel.diff
        patch --ignore-whitespace dockerfiles/rpm.dockerfile Dockerfile.rpm.diff
        
        make REF=v$CONTAINERD_VERSION BUILD_IMAGE=ecos0003:5000/rhel:7.9
        cp build/rhel/7/s390x/*.rpm $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/rhel-7/
       
        
        #Build RHEL-8 binaries
        mkdir -p $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/rhel-8
        
#       curl -o Dockerfile.rpm.diff $PATCH_URL/Dockerfile.rpm.diff
#       patch --ignore-whitespace dockerfiles/rpm.dockerfile Dockerfile.rpm.diff
        make REF=v$CONTAINERD_VERSION BUILD_IMAGE=ecos0003:5000/jenkins_slave_rhel:8.4
        cp build/rhel/8/s390x/*.rpm $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries/containerd/rhel-8/
        
        #Building Rhel 7 Docker-ce Binaries
        cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/rpm
        mkdir -p rhel-7
        cd $CURDIR/go/src/github.com/docker/docker-ce-packaging
        make -C rpm VERSION=$PACKAGE_VERSION rpmbuild/bundles-ce-rhel-7-s390x.tar.gz
        cp rpm/rpmbuild/bundles-ce-rhel-7-s390x.tar.gz $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries-tar/
        
        #Building Rhel 8 Docker-ce Binaries
        cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/rpm
        curl -o Makefile_rpm_docker-ce-packaging.diff $PATCH_URL/Makefile_rpm_docker-ce-packaging.diff
        patch --ignore-whitespace Makefile Makefile_rpm_docker-ce-packaging.diff
        mkdir -p rhel-8
        cd $CURDIR/go/src/github.com/docker/docker-ce-packaging/rpm/rhel-8
        curl -o Dockerfile https://$TOKEN@raw.github.ibm.com/loz/opensource-porting-s390x/master/Docker-CE/scripts/${PACKAGE_VERSION}/Dockerfile-rhel-8
        cd $CURDIR/go/src/github.com/docker/docker-ce-packaging
        make -C rpm VERSION=$PACKAGE_VERSION rpmbuild/bundles-ce-rhel-8-s390x.tar.gz
        cp rpm/rpmbuild/bundles-ce-rhel-8-s390x.tar.gz $CURDIR/${PACKAGE_NAME}-${PACKAGE_VERSION}-binaries-tar/    
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
        printf -- "\$CURDIR/docker-20.10.8-binaries/containerd \n"
        printf -- "\$CURDIR/docker-20.10.8-binaries/static \n "
        printf -- "\$CURDIR/docker-20.10.8-binaries/ubuntu-debs/ \n "
        printf -- "\n************************************************************************** \n"
        printf -- "For building containerd binaries you should first have a tagged release on the containerd(https://github.com/containerd/containerd/releases) repository."
        printf -- '\n'
}
###############################################################################################################
logDetails
checkPrequisites #Check Prequisites
DISTRO="$ID-$VERSION_ID"
case "$DISTRO" in
"ubuntu-18.04" | "ubuntu-20.04" | "ubuntu-21.04" |  "ubuntu-20.10" )
        printf -- "Installing %s %s for %s \n" "$PACKAGE_NAME" "$PACKAGE_VERSION" "$DISTRO" |& tee -a "$LOG_FILE"
        printf -- 'Installing the dependencies for Docker from repository \n' |& tee -a "$LOG_FILE"
        #sudo apt-get update -y >/dev/null
        #sudo apt-get install -y wget tar make jq docker.io |& tee -a "$LOG_FILE"
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
