## Simple webserver container 
## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .

# Using RHEL 7 base image and Apache Web server

# Pull the rhel image from the local repository
FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER connect-tech@redhat.com

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels#####
LABEL name="Web-app" \
      vendor="Example-Web-App" \
      version="1.2-1" \
      release="3" \
      run='docker run -d -p 8080:80 --name=web-app web-app' \
      summary="Example Corp's Starter app" \
      description="Starter app will do build a webserver" 


COPY licenses /licenses

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms \
### Add your package needs here
    INSTALL_PKGS="httpd" && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all


# Install the application
RUN echo "This container image was build on:" > /var/www/html/index.html
RUN date >> /var/www/html/index.html
EXPOSE 8080

#Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
