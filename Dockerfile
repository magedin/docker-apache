FROM httpd:2.4
MAINTAINER MagedIn Technology <support@magedin.com>

# ENVIRONMENT VARIABLES ------------------------------------------------------------------------------------------------

ENV APP_USER     www
ENV APP_GROUP    ${APP_USER}
ENV APP_HOME     /var/${APP_USER}
ENV APP_ROOT     ${APP_HOME}/html
ENV APACHE_ROOT  /usr/local/apache2
ENV APACHE_CONF  ${APACHE_ROOT}/conf

ENV SSL_DIR      ${APP_HOME}/ssl
ENV SSL_CA_DIR   ${SSL_DIR}/ca
ENV SSL_CERT_DIR ${SSL_DIR}/certificates
ENV CAROOT       ${SSL_CA_DIR}


# BASE INSTALLATION ----------------------------------------------------------------------------------------------------

RUN groupadd -g 1000 ${APP_USER} \
 && useradd -g 1000 -u 1000 -d ${APP_HOME} -s /bin/bash ${APP_GROUP}

RUN apt-get update && apt-get install -y \
  curl \
  libnss3-tools \
  openssl \
  vim \
  lsof \
  watch


RUN ( \
  cd /usr/local/bin/ \
  && curl -Lk http://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 -o mkcert \
  && chmod +x mkcert \
)


# BASE CONFIGURATION ---------------------------------------------------------------------------------------------------

COPY ./conf/httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p \
  ${APP_ROOT} \
  ${SSL_CA_DIR} \
  ${SSL_CERT_DIR} \
  ${APACHE_CONF}/vhosts

RUN (cd ${APP_HOME} && ln -s ${APACHE_ROOT})

RUN chown -R ${APP_USER}:${APP_GROUP} \
  ${APP_HOME} \
  ${SSL_CA_DIR} \
  ${SSL_CERT_DIR} \
  ${APACHE_ROOT}

VOLUME ${APP_HOME}

WORKDIR ${APP_ROOT}
