# lighttpd-centos7
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="kim  <:(@):>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV HIGHTTPD_VERSION=1.4.35

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for serving static HTML files" \
      io.k8s.display-name="Lighttpd 1.4.35" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,lighttpd."

# TODO: Install required packages here:
RUN yum install -y epel-release 
RUN yum install -y lighttpd && yum clean all -y

# Defines the location of the S2I
# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./s2i/bin/ /usr/local/s2i

# TODO (optional): Copy the builder files into /opt/app-root
COPY ./s2i/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
#COPY ./s2i/bin/ /root/go/bin/s2i

COPY ./etc/ /opt/app-root/etc

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root
RUN chmod -R 777 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["usage"]
