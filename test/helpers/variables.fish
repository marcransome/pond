set -x __pond_under_test yes
set pond_test_version (git describe --tags --abbrev=0)

set fail 1
set success 0

set pond_test_var_count 3

set pond_name_regular_prefix test-pond
set pond_name_private_prefix test-pond-private

set pond_name_regular $pond_name_regular_prefix-1
set pond_name_private $pond_name_private_prefix-1
