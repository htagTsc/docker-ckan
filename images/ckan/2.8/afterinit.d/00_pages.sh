#!/bin/sh
#ckan -plugin ckanext-pages pages initdb -c /srv/app/production.ini

paster --plugin=ckanext-pages pages initdb ---config=/srv/app/production.ini