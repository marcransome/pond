set -x __pond_under_test yes
set pond_test_version (git describe --tags --abbrev=0)

set fail 1
set success 0

set pond_name_prefix test-pond

set pond_name $pond_name_prefix-1
