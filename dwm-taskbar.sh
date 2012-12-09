#!/bin/bash
freq=2

format_number() {
    local num=$1
    local kilo=$(( $num / 1024 ))
    local mega=$(( $kilo / 1024 ))
    local giga=$(( $mega / 1024 ))

    if [[ $num -eq 0 ]]; then
        echo "$num"
    elif [[ $kilo -lt 1 ]]; then
        echo "${num}b"
    elif [[ $mega -lt 1 ]]; then
        echo "${kilo}k"
    elif [[ $giga -lt 1 ]]; then
        echo "${mega}M"
    else
        echo "${giga}G"
    fi
}

while :; do
    temp=$(sensors | sed s/[°+]//g | awk '
        BEGIN {
            sensed[0] = "";
            sensed[1] = "";
        }
        /^CPU Temperature:/ {
            sensed[0] = "CPU: " $3
        }
        /MB Temperature/ {
            sensed[1] = "MB: " $3
        }
        END {
            print sensed[0]" | "sensed[1]
        }
    ')

    load=$(uptime | sed 's/.*: //')

    mem=$(free | awk '
        /Mem:/ {
            total = $2;
        }
        /-\/\+ buffers\/cache/ {
            free = $4;
        }
        END {
            print int((1 - (free / total)) * 100);
        }
    ')

    eval $(awk "
        / *[a-z0-9]+:/ {
            gsub(/:$/, \"\", \$1);
            device = \$1
            stats[device][\"received\"] = \$2;
            stats[device][\"transmitted\"] = \$10;
        }
        END {
            has_previous = 0
            devices = \"\"
            for (device in stats) {
                received = stats[device][\"received\"];
                transmitted = stats[device][\"transmitted\"];
                if (received > 0 || transmitted > 0) {
                    devices = devices \" \" device
                    #if (has_previous) {
                    #    printf \" | \"
                    #}
                    #printf \"%s <%'.2i sent, %'.2i received>\", device, transmitted, received
                    printf \"%s_transmitted=%i; %s_received=%i;\", device, transmitted, device, received
                    has_previous = 1
                }
            }
            print \"devices=(\" devices \");\"
        }
    " /proc/net/dev)

    net=""
    for device in ${devices[*]}; do
        prev_transmitted=0
        prev_received=0
        eval "prev_transmitted=\${${device}_prev_transmitted:-0}"
        eval "prev_received=\${${device}_prev_received:-0}"

        eval "transmitted=\$${device}_transmitted"
        eval "received=\$${device}_received"

        this_transmitted=$(( $(( $transmitted - $prev_transmitted )) / $freq ))
        this_received=$(( $(( $received - $prev_received )) / $freq ))

        eval "${device}_prev_transmitted=$transmitted"
        eval "${device}_prev_received=$received"

        if [[ ! -z "$net" ]]; then
            net="$net | "
        fi
        net="${net}$device ^$(format_number $this_transmitted) v$(format_number $this_received)"
    done

    xsetroot -name "-- $net --    ^^ $mem% ^^    || $load ||    {{ $temp }}    $(date +"%Y-%m-%d %H:%M:%S")"

    sleep $freq
done
