#!/bin/bash

exec 1> /var/log/entrypoint.log 2>&1
set -x

#trap "echo TRAPed signal" HUP INT QUIT KILL TERM


/etc/init.d/rabbitmq-server start


cd /app/


python manage.py migrate

python manage.py compilemessages
echo "from django.contrib.auth.models import User; User.objects.create_superuser('change', 'sti@ufape.edu.br', 'change')" | python manage.py shell --plain
screen -d -m python manage.py celeryd --detach
#python manage.py runserver 0.0.0.0:8000




/etc/init.d/rabbitmq-server stop

apachectl -D FOREGROUND