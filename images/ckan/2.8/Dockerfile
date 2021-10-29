##################
### Build CKAN ###
##################
FROM alpine:3.14.2 as ckanbuild

# Used by Github Actions to tag the image with
ENV IMAGE_TAG=2.8.9

# Set CKAN version to build
ENV GIT_URL=https://github.com/ckan/ckan.git
ENV GIT_BRANCH=ckan-2.8.9

# Set src dirs
ENV SRC_DIR=/srv/app/src
ENV PIP_SRC=${SRC_DIR}

WORKDIR ${SRC_DIR}

# Packages to build CKAN requirements and plugins
RUN apk add --no-cache \
        git \
        curl \
        python2 \
        postgresql-dev \
        linux-headers \
        gcc \
        make \
        g++ \
        autoconf \
        automake \
        patch \
        libtool \
        musl-dev \
        pcre-dev \
        pcre \
        python2-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        geos \
        geos-dev \
        proj \
        proj-dev \
        proj-util

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python ${SRC_DIR}/get-pip.py 'pip==20.3.3'

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
### Default-Extensions ####
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
ENV HARVEST_GIT_URL=https://github.com/ckan/ckanext-harvest
ENV HARVEST_GIT_BRANCH=v1.2.1
ENV THEMING_GIT_URL=https://github.com/htagTsc/ckanext-custom_theme
ENV THEMING_GIT_BRANCH=1.0.1
ENV SPATIAL_GIT_URL=https://github.com/ckan/ckanext-spatial
ENV SPATIAL_GIT_BRANCH=v1.0.0
ENV DCAT_GIT_URL=https://github.com/htagTsc/ckanext-dcat/
ENV DCAT_GIT_BRANCH=v1.1.2.1
ENV DCATDE_GIT_URL=https://github.com/htagTsc/ckanext-dcatde
ENV DCATDE_GIT_BRANCH=4.4.1.1
ENV PAGES_GIT_URL=https://github.com/ckan/ckanext-pages
ENV PAGES_GIT_BRANCH=v0.3.3
ENV GEOVIEW_GIT_URL=https://github.com/ckan/ckanext-geoview
ENV GEOVIEW_GIT_BRANCH=v0.0.18
ENV PDFVIEW_GIT_URL=https://github.com/ckan/ckanext-pdfview
ENV PDFVIEW_GIT_BRANCH=0.0.7
ENV EXTRAFIELDS_GIT_URL=https://github.com/htagTsc/ckanext-extrafields
ENV EXTRAFIELDS_GIT_BRANCH=1.0.0
ENV OAUTH_GIT_URL=https://github.com/htagTsc/ckanext-oauth2
ENV OAUTH_GIT_BRANCH=v0.7.0.1


RUN apk add --no-cache \
        git \
        curl \
        python2 \
        python2-dev \
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

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python ${SRC_DIR}/get-pip.py 'pip==20.3.3'

# Fetch and build the default CKAN extensions
RUN pip wheel --wheel-dir=/wheels git+${ENVVARS_GIT_URL}@${ENVVARS_GIT_BRANCH}#egg=ckanext-envvars

#CKAN Harvester
RUN pip wheel --wheel-dir=/wheels git+${HARVEST_GIT_URL}@${HARVEST_GIT_BRANCH}#egg=ckanext-harvest
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-harvest/${HARVEST_GIT_BRANCH}/pip-requirements.txt
RUN curl -o /wheels/harvest.txt https://raw.githubusercontent.com/ckan/ckanext-harvest/${HARVEST_GIT_BRANCH}/pip-requirements.txt

#CKAN Theming extension 
RUN pip wheel --wheel-dir=/wheels git+${THEMING_GIT_URL}@${THEMING_GIT_BRANCH}#egg=ckanext-custom_theme
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/htagTsc/ckanext-custom_theme/${THEMING_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/custom_theme.txt https://raw.githubusercontent.com/htagTsc/ckanext-custom_theme/${THEMING_GIT_BRANCH}/requirements.txt

#CKAN DCAT extension
RUN pip wheel --wheel-dir=/wheels git+${DCAT_GIT_URL}@${DCAT_GIT_BRANCH}#egg=ckanext-dcat
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/htagTsc/ckanext-dcat/${DCAT_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/dcat.txt https://raw.githubusercontent.com/htagTsc/ckanext-dcat/${DCAT_GIT_BRANCH}/requirements.txt

#CKAN Spatial 
RUN pip wheel --wheel-dir=/wheels git+${SPATIAL_GIT_URL}@${SPATIAL_GIT_BRANCH}#egg=ckanext-spatial
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-spatial/${SPATIAL_GIT_BRANCH}/requirements-py2.txt
RUN curl -o /wheels/spatial.txt https://raw.githubusercontent.com/ckan/ckanext-spatial/${SPATIAL_GIT_BRANCH}/requirements-py2.txt

#CKAN Pages extension
RUN pip wheel --wheel-dir=/wheels git+${PAGES_GIT_URL}@${PAGES_GIT_BRANCH}#egg=ckanext-pages
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-pages/${PAGES_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/pages.txt https://raw.githubusercontent.com/ckan/ckanext-pages/${PAGES_GIT_BRANCH}/requirements.txt

#CKAN DCATDE extension
RUN pip wheel --wheel-dir=/wheels git+${DCATDE_GIT_URL}@${DCATDE_GIT_BRANCH}#egg=ckanext-dcatde
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/htagTsc/ckanext-dcatde/${DCATDE_GIT_BRANCH}/base-requirements.txt
RUN curl -o /wheels/dcatde.txt https://raw.githubusercontent.com/htagTsc/ckanext-dcatde/${DCATDE_GIT_BRANCH}/base-requirements.txt

#CKAN GEOVIEW extension
RUN pip wheel --wheel-dir=/wheels git+${GEOVIEW_GIT_URL}@${GEOVIEW_GIT_BRANCH}#egg=ckanext-geoview
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt
RUN curl -o /wheels/geoview.txt https://raw.githubusercontent.com/ckan/ckanext-geoview/${GEOVIEW_GIT_BRANCH}/pip-requirements.txt

#CKAN PDFVIEW extension
RUN pip wheel --wheel-dir=/wheels git+${PDFVIEW_GIT_URL}@${PDFVIEW_GIT_BRANCH}#egg=ckanext-pdfview

#CKAN Extrafields extension 
RUN pip wheel --wheel-dir=/wheels git+${EXTRAFIELDS_GIT_URL}@${EXTRAFIELDS_GIT_BRANCH}#egg=ckanext-extrafields

#CKAN OAuth2 extension 
RUN pip wheel --wheel-dir=/wheels git+${OAUTH_GIT_URL}@${OAUTH_GIT_BRANCH}#egg=ckanext-outh2
RUN pip wheel --wheel-dir=/wheels -r https://raw.githubusercontent.com/htagTsc/ckanext-oauth2/${OAUTH_GIT_BRANCH}/requirements.txt
RUN curl -o /wheels/oauth2.txt https://raw.githubusercontent.com/htagTsc/ckanext-oauth2/${OAUTH_GIT_BRANCH}/requirements.txt

############
### MAIN ###
############
FROM alpine:3.14.2

LABEL maintainer="Keitaro Inc <info@keitaro.com>"
LABEL org.opencontainers.image.source https://github.com/keitaroinc/docker-ckan

ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_DIR=${SRC_DIR}/ckan
ENV DATA_DIR=/srv/app/data
ENV PIP_SRC=${SRC_DIR}
ENV CKAN_SITE_URL=http://localhost:5000
ENV CKAN__PLUGINS envvars image_view pdf_view recline_view text_view webpage_view datastore datapusher custom_theme extrafields harvest ckan_harvester geo_view geojson_view wmts_view shp_view dcat dcatde dcatde_rdf_harvester pages resource_proxy spatial_metadata spatial_query oauth2

# Install necessary packages to run CKAN
RUN apk add --no-cache git \
        bash \
        gettext \
        curl \
        postgresql-client \
        python2 \
        libmagic \
        pcre \
        libxslt \
        libxml2 \
        tzdata \
        libffi-dev \
        libxslt-dev \
        geos \
        geos-dev \
        proj \
        proj-dev \
        proj-util \
        apache2-utils && \
        
    # Create SRC_DIR
    mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python ${SRC_DIR}/get-pip.py 'pip==20.3.3'

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
    pip install --no-index --find-links=/srv/app/wheels -r requirements.txt && \
    # Install default CKAN extensions
    
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-envvars && \

    #CKAN harvester
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-harvest && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/harvest.txt && \

    #CKAN Theming
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-custom_theme && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/custom_theme.txt && \
    
    #CKAN SPATIAL
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-spatial && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/spatial.txt && \

    #CKAN DCAT
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-dcat && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/dcat.txt && \

    #CKAN PAGES
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-pages && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/pages.txt && \

    #CKAN DCATDE
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-dcatde && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/dcatde.txt && \

    #CKAN GEOVIEW
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-geoview && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/geoview.txt && \

    #CKAN PDFVIEW
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-pdfview && \

    #CKAN Extrafields
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-extrafields && \

    #CKAN Oauth2
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-oauth2 && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r /srv/app/ext_wheels/oauth2.txt && \

    # Create and update CKAN config
    # Set timezone
    echo "UTC" >  /etc/timezone && \

    curl -o /srv/app/dcat_theme.json https://raw.githubusercontent.com/htagTsc/ckanext-dcatde/${DCATDE_GIT_BRANCH}/examples/dcat_theme.json && \
    curl -o /srv/app/dcat_licenses.json https://raw.githubusercontent.com/htagTsc/ckanext-dcatde/${DCATDE_GIT_BRANCH}/examples/dcat_licenses.json && \

    # Generate CKAN config
    paster --plugin=ckan make-config ckan ${APP_DIR}/production.ini && \
    paster --plugin=ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}" && \
    #paster --plugin=ckan config-tool ${APP_DIR}/production.ini "license_group_url = /srv/app/dcat_licenses.json" && \
    #paster --plugin=ckan config-tool ${APP_DIR}/production.ini "ckanext.dcatde.urls.themes = ../../dcat_theme.json" && \

    # Set the default level for extensions to INFO
    paster --plugin=ckan config-tool ${APP_DIR}/production.ini -s logger_ckanext -e level=WARNING && \
    # Create the data directory
    mkdir ${DATA_DIR} && \
    # Change ownership to app user
    chown -R ckan:ckan /srv/app

# Remove wheels
RUN rm -rf /srv/app/wheels /srv/app/ext_wheels

# Add afterinit scripts
COPY ./afterinit.d/00_harvest.sh ${APP_DIR}/docker-afterinit.d/00_harvest.sh
COPY ./afterinit.d/00_spatial.sh ${APP_DIR}/docker-afterinit.d/00_spatial.sh
COPY ./afterinit.d/00_pages.sh ${APP_DIR}/docker-afterinit.d/00_pages.sh
COPY ./afterinit.d/00_dcatde.sh ${APP_DIR}/docker-afterinit.d/00_dcatde.sh

# Copy necessary scripts
COPY setup/app ${APP_DIR}

WORKDIR ${APP_DIR}

# Copy the alias script for paster to be ckan so it's compatible with 2.9
COPY setup/bin/ckan /usr/bin/ckan

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir docker-entrypoint.d

# Create afterinit directory for children image scripts
ONBUILD RUN mkdir docker-afterinit.d

EXPOSE 5000

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD curl --fail http://localhost:5000/api/3/action/status_show || exit 1

USER ckan

CMD ["/srv/app/start_ckan.sh"]
