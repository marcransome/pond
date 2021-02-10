set fail 1
set success 0

set -x pond_name pond
set -x var_name var
set -x var_value value
set -x no_exist none

set -x no_var_operation_specified_error "No variable operation specified"
set -x no_pond_name_specified_error "No pond name specified"
set -x no_var_name_specified_error "No variable name specified"
set -x no_var_value_specified_error "No variable value specified"
set -x no_pond_error "Pond does not exist"

function __pond_setup
    pond create $pond_name
end

function __pond_tear_down
    echo 'y' | pond remove $pond_name
end

__pond_setup
for command in var variable
    @echo "missing variable operation error tests (e.g. 'pond var|variable')"
    @test "$command command without operation name reports error" (pond $command 2>&1) = $no_var_operation_specified_error
    @test "$command command without operation name produces exit code failure" (pond $command >/dev/null 2>&1) $status -eq $fail

    @echo "missing pond name error tests (e.g. 'pond var|variable ls|list|set|get|rm|remove')"
    for operation in ls list set get rm remove
        @test "$command $operation operation without pond name reports error" (pond $command $operation 2>&1) = $no_pond_name_specified_error
        @test "$command $operation operation without pond name produces exit code failure" (pond $command $operation >/dev/null 2>&1) $status -eq $fail
    end

    @echo "missing variable name error tests (e.g. 'pond var|variable set|get|rm|remove <pond-name>')"
    for operation in set get rm remove
        @test "$command $operation operation without variable name reports error" (pond $command $operation $pond_name 2>&1) = $no_var_name_specified_error
        @test "$command $operation operation without variable name produces exit code failure" (pond $command $operation $pond_name >/dev/null 2>&1) $status -eq $fail
    end

    @echo "missing variable value tests (e.g. 'pond var|variable set <pond-name> <var-name>')"
    @test "$command set operation without variable name reports error" (pond $command set $pond_name $var_name 2>&1) = $no_var_value_specified_error
    @test "$command set operation without variable name produces exit code failure" (pond $command set $pond_name $var_name >/dev/null 2>&1) $status -eq $fail

    @echo "non-existent pond error tests (e.g. pond var|variable ls|list|set|get|rm|remove <non-existent-pond>)"
    for operation in ls list set get rm remove
        @test "$command $operation output for non-existent pond reports error" (pond $command $operation $no_exist 2>&1) = $no_pond_error
        @test "$command $operation fails for non-existent pond" (pond $command $operation $no_exist >/dev/null 2>&1) $status -eq $fail
    end
end
__pond_tear_down

set -e __pond_setup
set -e __pond_tear_down
