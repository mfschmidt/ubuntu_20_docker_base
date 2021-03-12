#!/bin/bash

# Handle arguments
usage() {
	echo "Usage: $0 [-u <userid>] [-g <groupid>] [-n <username>] [-p <participantid>]"
	exit 1
}

while getopts ":u:g:p:n:" opt; do
	case ${opt} in
		u) ID_USER=${OPTARG}
		;;
		g) ID_GROUP=${OPTARG}
		;;
		n) USER_NAME=${OPTARG}
		;;
		p) PARTICIPANT=${OPTARG}
		;;
		*) usage ;;
	esac
done
shift $((OPTIND-1))

# Handle user and group, if necessary
if [[ "${ID_GROUP}" == "" ]]; then
	# Passing only a user id is OK, we assume group id should match.
	ID_GROUP=${ID_USER}
fi
if [[ "${ID_USER}" != "" ]]; then
	# Create user:group that matches the host user running this container.
	if [[ "${USER_NAME}" == "" ]]; then
		USER_NAME="dockeruser"
	fi
	echo "Creating '${USER_NAME}' ${ID_USER}:${ID_GROUP}"
	groupadd --gid ${ID_GROUP} ${USER_NAME}
	useradd --no-create-home --home-dir /code --shell /bin/bash --no-log-init --uid ${ID_USER} --gid ${ID_GROUP} ${USER_NAME}
	usermod -aG sudo ${USER_NAME}
fi

# Run the container
if [[ "${ID_USER}" == "" ]]; then
	/code/run.py
else
	su ${USER_NAME} -c '/code/run.py'
fi
