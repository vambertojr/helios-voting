FROM python:2.7.18-buster

SHELL ["/bin/bash", "-c"]

RUN apt update \
    && apt install -y apache2 libapache2-mod-wsgi build-essential git gettext python-pip python-ldap   \
    python-dev libsasl2-dev libldap2-dev curl sudo apt-transport-https screen libpq-dev \
    && mkdir /app

RUN curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add - \
    && apt-key adv --keyserver "hkps://keys.openpgp.org" --recv-keys "0x0A9AF2115F4687BD29803A206B73A36E6026DFCA"

RUN apt-get update && apt-get install -y rabbitmq-server



#RUN virtualenv /env \
#    && source ./env/bin/activate
     
COPY ./app/requirements.txt ./
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./app/ /app
COPY ./helios.conf /etc/apache2/sites-available/000-default.conf

RUN chmod +x /docker-entrypoint.sh

WORKDIR /app
RUN pip install --quiet --no-cache-dir -r requirements.txt
RUN pip install httplib2 oauth2client celery bleach unicodecsv validate_email python-ldap django-auth-ldap django-celery djangosecure
RUN a2enmod rewrite \
    && a2enmod ssl
RUN export C_FORCE_ROOT="true"

RUN adduser --disabled-login --quiet --gecos Helios helios
RUN chown helios:helios /app -R
RUN adduser helios sudo

RUN apt-get purge --purge -y build-essential && apt-get autoremove -y

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

