Name:           checkpolicy
Version:        3.2.61.1
Release:        1%{?dist}
Group:          System Environment/Base
Summary:        policycoreutils package
License:        GPLv2
%description

%configure

%install
wget https://github.com/SELinuxProject/selinux/releases/download/3.2/libsepol-3.2.tar.gz
zypper install -y wget tar gcc7 make gzip bison libsepol-devel flex
tar -xvf libsepol-3.2.tar.gz
cd libsepol-3.2
make CC=gcc
cd ..
wget https://github.com/SELinuxProject/selinux/releases/download/3.2/checkpolicy-3.2.tar.gz
tar -xvf checkpolicy-3.2.tar.gz
cd checkpolicy-3.2
make CC=gcc
%files
