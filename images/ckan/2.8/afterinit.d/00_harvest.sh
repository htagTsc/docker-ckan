#!/bin/sh
#ckan -plugin ckanext-harvest harvester initdb -c /srv/app/production.ini
#ckan --config=/etc/ckan/default/ckan.ini harvester initdb
paster --plugin=ckanext-harvest harvester initdb --config=/srv/app/production.ini