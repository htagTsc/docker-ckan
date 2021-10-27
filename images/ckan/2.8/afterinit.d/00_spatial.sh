#!/bin/sh
#ckan -plugin ckanext-spatial spatial initdb -c /srv/app/production.ini

paster --plugin=ckanext-spatial spatial initdb 4326 --config=/srv/app/production.ini
paster --plugin=ckanext-spatial spatial extents --config=/srv/app/production.ini