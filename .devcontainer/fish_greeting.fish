function fish_greeting
    if test -f /etc/motd
        cat /etc/motd
    end
end
