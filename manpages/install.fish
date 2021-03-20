#!/usr/bin/env fish

if ! command -q curl
    echo "Curl is required to proceed with the installation; exiting"
    exit 1
end

set http_code (curl --write-out "%{http_code}" --silent "https://raw.githubusercontent.com/marcransome/pond/main/manpages/pond.1" -o /usr/local/share/man/man1/pond.1)
set curl_exit $status

if test $curl_exit -ne 0
    echo "A curl error occurred when installing the man page: $curl_exit"
    exit 1
else if test $http_code -ne 200
    echo "A HTTP error occurred when retrieving the man page: $http_code"
    exit 1
else
    echo "pond(1) man page installed"
    exit 0
end
