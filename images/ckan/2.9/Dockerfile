##################
### Build CKAN ###
##################
FROM alpine:3.14.2 as ckanbuild

# Used by Github Actions to tag the image with
ENV IMAGE_TAG=2.9.4

# Set CKAN version to build
ENV GIT_URL=https://github.com/ckan/ckan.git
# Should be downgrade to Version 2.8 and python to version 2.7
ENV GIT_BRANCH=ckan-2.9.4 

# Set src dirs
ENV SRC_DIR=/srv/app/src
ENV PIP_SRC=${SRC_DIR}

WORKDIR ${SRC_DIR}

# Packages to build CKAN requirements and plugins
# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 \
        python3-dev=3.8.10-r0 && \
    apk add --no-cache \
        git \
        curl \
        postgresql-dev \
        linux-headers \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        patch \
        musl-dev \
        pcre-dev \
        pcre \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        gcc \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        geos \
        geos-dev \
        proj \
        proj-dev \
        proj-util

# Link python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Downgrade setuptools so that CKAN requirements can be built
RUN pip install setuptools==44.1.0

# Fetch and build CKAN and requirements
RUN pip install -e git+${GIT_URL}@${GIT_BRANCH}#egg=ckan
# Copy patches and apply patches script
COPY ./patches ${SRC_DIR}/patches
COPY ./scripts/apply_ckan_patches.sh ${SRC_DIR}/apply_ckan_patches.sh
# Apply patches
RUN ${SRC_DIR}/apply_ckan_patches.sh
RUN rm -rf /srv/app/src/ckan/.git
RUN pip wheel --wheel-dir=/wheels -r ckan/requirements.txt
RUN pip wheel --wheel-dir=/wheels uwsgi==2.0.19.1 gevent==21.1.2 greenlet==1.1.0


###########################
###### Extensions ########
###########################
FROM alpine:3.14.2 as extbuild

# Set src dirs
ENV SRC_DIR=/srv/app/src
ENV PIP_SRC=${SRC_DIR}

# List of default extensions
ENV DEFAULT_EXTENSIONS envvars

# Locations and tags, please use specific tags or revisions
ENV ENVVARS_GIT_URL=https://github.com/okfn/ckanext-envvars
ENV ENVVARS_GIT_BRANCH=0.0.1
#ENV SCHEMING_GIT_URL=https://github.com/ckan/ckanext-scheming --> To be used if dcatde plugin is not working at the end
#ENV SCHEMING_GIT_BRANCH=release-2.1.0
ENV HARVEST_GIT_URL=https://github.com/ckan/ckanext-harvest
ENV HARVEST_GIT_BRANCH=v1.3.3
#ENV THEMING_GIT_URL=https://github.com/rostock/ckanext-hro_theme --> Not Python3 ready
#ENV THEMING_GIT_BRANCH=master
#ENV THEMING_GIT_URL=https://github.com/ongov/ckanext-ontario_theme --> Not Python3 ready
#ENV THEMING_GIT_BRANCH=v1.0
#ENV SPATIAL_GIT_URL=https://github.com/ckan/ckanext-spatial --> Missing Postgis Database
#ENV SPATIAL_GIT_BRANCH=v1.0.0
ENV DCAT_GIT_URL=https://github.com/ckan/ckanext-dcat
ENV DCAT_GIT_BRANCH=v1.1.2
#ENV DCATDE_GIT_URL=https://github.com/htagTsc/ckanext-hro_theme --> Not Python3 ready
#ENV DCATDE_GIT_BRANCH=master
ENV VISUALIZE_GIT_URL=https://github.com/keitaroinc/ckanext-visualize
ENV VISUALIZE_GIT_BRANCH=v1.0.0
ENV PAGES_GIT_URL=https://github.com/ckan/ckanext-pages
ENV PAGES_GIT_BRANCH=v0.3.3
ENV GEOVIEW_GIT_URL=https://github.com/ckan/ckanext-geoview
ENV GEOVIEW_GIT_BRANCH=v0.0.18
#ENV CHARTS_GIT_URL=https://github.com/ckan/ckanext-basiccharts --> Not Python3 ready
#ENV CHARTS_GIT_BRANCH=master
#ENV OAUTH_GIT_URL=https://github.com/conwetlab/ckanext-oauth2 --> Not Python3 ready
#ENV OAUTH_GIT_BRANCH=0.7.0

# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 \
        python3-dev=3.8.10-r0 && \
    apk add --no-cache \
        git \
        curl \
        postgresql-dev \
        linux-headers \
        make \
        g++ \
        gcc \
        autoconf \
        automake \
        libtool \
        patch \
        musl-dev \
        pcre-dev \
        pcre \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        geos \
        geos-dev \
        proj \
        proj-dev \
        proj-util 
        
# Link python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Downgrade setuptools so that CKAN requirements can be built
RUN pip install setuptools==44.1.0

# Fetch and build the CKAN envvars extension --> Seems to work
RUN pip wheel --wheel-dir=/wheels git+${ENVVARS_GIT_URL}@${ENVVARS_GIT_BRANCH}#egg=ckanext-envvars

# Fetch and build the CKAN Scheming extension
#RUN pip wheel --wheel-dir=/wheels git+${SCHEMING_GIT_URL}@${SCHEMING_GIT_BRANCH}#egg=ckanext-scheming

#CKAN Harvester
RUN pip wheel --wheel-dir=/wheels git+${HARVEST_GIT_URL}@${HARVEST_GIT_BRANCH}#egg=ckanext-harvest
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-harvest/${HARVEST_GIT_BRANCH}/pip-requirements.txt
RUN curl -o /wheels/harvest.txt https://raw.githubusercontent.com/ckan/ckanext-harvest/${HARVEST_GIT_BRANCH}/pip-requirements.txt

#CKAN Theming extension
#RUN pip wheel --wheel-dir=/wheels git+${THEMING_GIT_URL}@${THEMING_GIT_BRANCH}#egg=ckanext-hro_theme
#RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/rostock/ckanext-hro_theme/${THEMING_GIT_BRANCH}/requirements.txt
#RUN curl -o /wheels/hro_theme.txt https://raw.githubusercontent.com/rostock/ckanext-hro_theme/${THEMING_GIT_BRANCH}/requirements.txt

#CKAN DCAT extension
RUN pip wheel --wheel-dir=/wheels git+${DCAT_GIT_URL}@${DCAT_GIT_BRANCH}#egg=ckanext-dcat
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-dcat/${DCAT_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/dcat.txt https://raw.githubusercontent.com/ckan/ckanext-dcat/${DCAT_GIT_BRANCH}/requirements.txt

#CKAN Spatial
#RUN pip wheel --wheel-dir=/wheels git+${SPATIAL_GIT_URL}@${SPATIAL_GIT_BRANCH}#egg=ckanext-spatial
#RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-spatial/${SPATIAL_GIT_BRANCH}/requirements.txt
#RUN curl -o /wheels/spatial.txt https://raw.githubusercontent.com/ckan/ckanext-spatial/${SPATIAL_GIT_BRANCH}/requirements.txt

#CKAN Pages extension
RUN pip wheel --wheel-dir=/wheels git+${PAGES_GIT_URL}@${PAGES_GIT_BRANCH}#egg=ckanext-pages
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-pages/${PAGES_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/pages.txt https://raw.githubusercontent.com/ckan/ckanext-pages/${PAGES_GIT_BRANCH}/requirements.txt

#CKAN VISUALIZE extension
RUN pip wheel --wheel-dir=/wheels git+${VISUALIZE_GIT_URL}@${VISUALIZE_GIT_BRANCH}#egg=ckanext-visualize
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/keitaroinc/ckanext-visualize/${VISUALIZE_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/visualize.txt https://raw.githubusercontent.com/keitaroinc/ckanext-visualize/${VISUALIZE_GIT_BRANCH}/requirements.txt

#CKAN DCATDE extension
#RUN pip wheel --wheel-dir=/wheels git+${DCATDE_GIT_URL}@${DCATDE_GIT_BRANCH}#egg=ckanext-hro_dcatapde
#RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/rostock/ckanext-hro_dcatapde/${DCATDE_GIT_BRANCH}/requirements.txt
#RUN curl -o /wheels/hro_dcatapde.txt https://raw.githubusercontent.com/rostock/ckanext-hro_dcatapde/${DCATDE_GIT_BRANCH}/requirements.txt

#CKAN GEOVIEW extension
RUN pip wheel --wheel-dir=/wheels git+${GEOVIEW_GIT_URL}@${GEOVIEW_GIT_BRANCH}#egg=ckanext-geoview
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt
RUN curl -o /wheels/geoview.txt https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt

#CKAN CHARTS extension
#RUN pip wheel --wheel-dir=/wheels git+${CHARTS_GIT_URL}@${CHARTS_GIT_BRANCH}#egg=ckanext-basiccharts
#RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt
#RUN curl -o /wheels/geoview.txt https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt


############
### MAIN ###
############
FROM alpine:3.14.2

LABEL originator="Keitaro Inc <info@keitaro.com>"
LABEL org.opencontainers.image.source https://github.com/keitaroinc/docker-ckan

ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_DIR=${SRC_DIR}/ckan
ENV DATA_DIR=/srv/app/data
ENV PIP_SRC=${SRC_DIR}
ENV CKAN_SITE_URL=http://localhost:5000
ENV CKAN__PLUGINS envvars image_view text_view datastore datapusher harvest ckan_harvester dcat dcat_rdf_harvester dcat_json_harvester dcat_json_interface structured_data visualize pages resource_proxy geo_view geojson_view wmts_view shp_view
#dcatde dcatde_rdf_harvester spatial_metadata spatial_query hro_theme scheming_datasets scheming_groups scheming_organizations
# Install necessary packages to run CKAN
# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 && \
    apk add --no-cache git \
        bash \
        gettext \
        curl \
        postgresql-client \
        libmagic \
        pcre \
        libxslt \
        libxml2 \
        tzdata \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        geos \
        geos-dev \
        proj \
        proj-dev \
        proj-util \
        apache2-utils && \
    # Create SRC_DIR
    mkdir -p ${SRC_DIR} && \
    # Link python to python3
    ln -s /usr/bin/python3 /usr/bin/python

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Get artifacts from build stages
COPY --from=ckanbuild /wheels /srv/app/wheels
COPY --from=extbuild /wheels /srv/app/ext_wheels
COPY --from=ckanbuild /srv/app/src/ckan ${CKAN_DIR}

# Additional install steps for build stages artifacts
RUN pip install --no-index --find-links=/srv/app/wheels uwsgi==2.0.19.1 gevent==21.1.2

# Create a local user and group to run the app
RUN addgroup -g 92 -S ckan && \
    adduser -u 92 -h /srv/app -H -D -S -G ckan ckan

WORKDIR ${CKAN_DIR}

# Install CKAN
RUN pip install -e /srv/app/src/ckan && \
    cp who.ini ${APP_DIR} && \
    
    #CKAN envvars 
    pip install --no-index --find-links=/srv/app/wheels -r requirements.txt && \
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-envvars && \

    #CKAN harvester
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-harvest && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/harvest.txt && \

    #CKAN Scheming
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-scheming && \

    #CKAN Theming
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-hro_theme && \
    #pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/hro_theme.txt && \
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-datawagovautheme && \
    
    #CKAN DCAT
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-dcat && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/dcat.txt && \

    #CKAN SPATIAL
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-spatial && \
    #pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/spatial.txt && \

    #CKAN VISUALIZE
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-visualize && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/visualize.txt && \

    #CKAN PAGES
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-pages && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/pages.txt && \

    #CKAN DCATDE
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-hro_dcatapde && \
    #pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/hro_dcatapde.txt && \

    #CKAN GEOVIEW
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-geoview && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/geoview.txt && \

    #CKAN BASICCHARTS
    #pip install --no-index --find-links=/srv/app/ext_wheels ckanext-basiccharts && \
    #pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/geoview.txt && \

    # Create and update CKAN config
    # Set timezone
    echo "UTC" >  /etc/timezone && \
    # Generate CKAN config
    ckan generate config ${APP_DIR}/production.ini && \
    # Configure plugins
    ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}" && \
    # Create the data directory
    mkdir ${DATA_DIR} && \
    # Webassets can't be loaded from env variables at runtime, it needs to be in the config so that it is created
    ckan config-tool ${APP_DIR}/production.ini "ckan.webassets.path = ${DATA_DIR}/webassets" && \
    # Set the default level for extensions to INFO
    ckan config-tool ${APP_DIR}/production.ini -s logger_ckanext -e level=WARNING && \
    # Change ownership to app user
    chown -R ckan:ckan /srv/app

# Remove wheels
RUN rm -rf /srv/app/wheels /srv/app/ext_wheels

# Add afterinit scripts
COPY ./afterinit.d/00_harvest.sh ${APP_DIR}/docker-afterinit.d/00_harvest.sh
#COPY ./afterinit.d/00_spatial.sh ${APP_DIR}/docker-afterinit.d/00_spatial.sh
#COPY ./afterinit.d/00_scheming.sh ${APP_DIR}/docker-afterinit.d/00_scheming.sh
#COPY ./afterinit.d/00_fluent.sh ${APP_DIR}/docker-afterinit.d/00_fluent.sh
#COPY ./afterinit.d/00_theming.sh ${APP_DIR}/docker-afterinit.d/00_theming.sh
COPY ./afterinit.d/00_dcat.sh ${APP_DIR}/docker-afterinit.d/00_dcat.sh
COPY ./afterinit.d/00_visualize.sh ${APP_DIR}/docker-afterinit.d/00_visualize.sh
COPY ./afterinit.d/00_pages.sh ${APP_DIR}/docker-afterinit.d/00_pages.sh
COPY ./afterinit.d/00_geoview.sh ${APP_DIR}/docker-afterinit.d/00_geoview.sh
#COPY ./afterinit.d/00_dcatapde.sh ${APP_DIR}/docker-afterinit.d/00_dcatapde.sh
#COPY ./afterinit.d/00_charts.sh ${APP_DIR}/docker-afterinit.d/00_charts.sh


# Copy necessary scripts
COPY setup/app ${APP_DIR}

WORKDIR ${APP_DIR}

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir docker-entrypoint.d

# Create afterinit directory for children image scripts
ONBUILD RUN mkdir docker-afterinit.d

EXPOSE 5000

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD curl --fail http://localhost:5000/api/3/action/status_show || exit 1

USER ckan

CMD ["/srv/app/start_ckan.sh"]
