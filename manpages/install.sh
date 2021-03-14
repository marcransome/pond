#!/usr/bin/env bash

set -u

if ! command -v curl >/dev/null; then
    echo "Curl is required to proceed with the installation; exiting"
    exit 1
fi

http_code=$(curl --write-out "%{http_code}" --silent "https://raw.githubusercontent.com/marcransome/pond/main/manpages/pond.1" -o /usr/local/share/man/man1/pond.1)

if [[ $? -ne 0 ]]; then
    echo "A curl error occurred when retrieving the man page: $status"
    exit 1
elif [[ $http_code -ne 200 ]]; then
    echo "A HTTP error occurred when retrieving the man page: $http_code"
    exit 1
else
    echo "pond(1) man page installed"
    exit 0
fi
