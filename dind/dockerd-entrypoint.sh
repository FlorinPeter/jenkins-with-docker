#!/bin/sh
# Source: https://github.com/docker-library/docker/blob/2e8569cf5c665ef955855e95be475f52a55c0720/1.8/dind/dockerd-entrypoint.sh

set -e

if [ "$#" -eq 0 -o "${1:0:1}" = '-' ]; then
	set -- docker daemon \
		--host=unix:///var/run/docker.sock \
		--host=tcp://0.0.0.0:2375 \
		--storage-driver=vfs \
		${DOCKER_OPTS}
		"$@"
fi

if [ "$1" = 'docker' -a "$2" = 'daemon' ]; then
	# if we're running Docker, let's pipe through dind
	# (and we'll run dind explicitly with "sh" since its shebang is /bin/bash)
	echo "sh $(which dind) $@"
	set -- sh "$(which dind)" "$@"
fi

echo "exec: $@"
exec "$@"
