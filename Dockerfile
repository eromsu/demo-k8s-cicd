############################################################
# Dockerfile to build NSO Local-Install Container
############################################################

# Base image
FROM centos:7

# Give root user a password
RUN echo "root:cisco123" | chpasswd

# yum init
#RUN yum -y update; yum clean all
#RUN yum --enablerepo=extras install -y epel-release; yum clean all

# Install Packages
RUN yum -y update && yum install -y \
    python3 \
    python-devel \
    libffi-devel \
    python3-pip \
    curl \
    java-11-openjdk-devel \
    ant \ 
    openssh-server

# Pip install and upgrade
RUN pip3 install paramiko && \
    pip3 install --upgrade pip

# Copy Scripts 
RUN mkdir nso_install5.3 && \
curl -u vagrant:vagrant 172.42.42.110/nso-5.3.linux.x86_64.installer.bin -o nso_install5.3/nso-5.3.linux.x86_64.installer.bin
#COPY nso-5.3.linux.x86_64.installer.bin nso_install5.3

#Change default python 
RUN alias python='/usr/bin/python3.6'
EXPOSE 8080 830 2022 2023 4569

#Install NSO
RUN sh nso_install5.3/nso-5.3.linux.x86_64.installer.bin $HOME/nso-5.3
RUN echo source $HOME/nso-5.3/ncsrc >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc; ncs-setup --dest $HOME/ncs-run; cd $HOME/ncs-run"]

# Start NSO
# ENTRYPOINT ["ncs"] 
