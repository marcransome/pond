set -gx pond_home (mktemp -d /tmp/pond-test-XXXXXX)

set -x __pond_under_test yes

set pond_test_version_number (git describe --tags --abbrev=0)
set pond_test_version_string "pond $pond_test_version_number ("(uname -s) (uname -m)")"

set failure 1
set success 0

set pond_name_prefix test-pond

set pond_name $pond_name_prefix-1
