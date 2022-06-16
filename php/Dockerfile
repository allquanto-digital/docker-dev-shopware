FROM allquantodevops/php

ARG UID=1000
ARG GID=1000
ARG USER=app

ENV HOMEDIR=/var/www/html \
    PHP_MEMORY_LIMIT=2048M

RUN addgroup -g ${GID} ${USER} && \
    adduser --shell /bin/bash --disabled-password \
    --no-create-home --uid $UID --ingroup $USER $USER

# ADD ./entrypoint.sh /usr/local/bin/docker-php-entrypoint
# RUN chmod a+x /usr/local/bin/docker-php-entrypoint

RUN chown -R ${UID}:${GID} ${HOMEDIR}
RUN chown -R ${UID}:${GID} /root/.composer
RUN mkdir -p ${HOMEDIR}/.composer && chown -R ${UID}:${GID} ${HOMEDIR}/.composer
RUN mkdir -p ${HOMEDIR}/.config && chown -R ${UID}:${GID} ${HOMEDIR}/.config
RUN mkdir -p ${HOMEDIR}/.npm \
    && npm config set cache ${HOMEDIR}/.npm \
    && chown -R ${UID}:${GID} ${HOMEDIR}/.npm
USER ${UID}
