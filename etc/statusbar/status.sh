#!/bin/sh

battery() {
    acpi --battery |
    cut -f 2 -d "," |
    cut -f 2 -d " " |
    grep -oE "[0-9]+" |
    sort |
    tail -n 1

    acpi --ac-adapter |
    grep -oE "(on|off)-line"
}

battery_icon() {
    read value
    read ac_adapter

    if [ $ac_adapter = "on-line" ]
    then
        echo "battery_charging_full"
    else
        echo "battery_full"
    fi

    exit

    if [ $value -eq 100 ]
    then
        echo "battery_full"
    elif [ $value -ge 90 ]
    then
        echo "battery_90"
    elif [ $value -ge 80 ]
    then
        echo "battery_80"
    elif [ $value -ge 60 ]
    then
        echo "battery_60"
    elif [ $value -ge 50 ]
    then
        echo "battery_50"
    elif [ $value -ge 30 ]
    then
        echo "battery_30"
    elif [ $value -ge 20 ]
    then
        echo "battery_20"
    else
        echo "battery_alert"
    fi
}

current_time() {
    date +"%Y-%m-%dT%H:%M"
}

volume() {
    amixer scontents |
    grep "%" |
    head -n 1 |
    cut -f 2 -d "[" |
    cut -f 1 -d "]" |
    grep -oE "[0-9]+"
}

volume_icon() {
    read value

    if [ $value -eq 0 ]
    then
        echo "volume_mute"
    else
        echo "volume_up"
    fi
}

cat <<EOF
<!doctype html>
<html>
<head>
    <style>
        html {
            background-color: #000000;
            color: #FFFFFF;
            font-family: 'Roboto';
            font-weight: 500;

            -webkit-font-smoothing: antialiased;
        }

        html, body {
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            align-items: center;
            padding: 0 1em;
        }

        .container > * {
            display: flex;
            align-items: center;
        }

        .container > :not(:first-child) {
            margin-left: 1em;
        }

        .container > * > :not(:first-child) {
            margin-left: 0.25em;
        }

        .material-icons {
            font-family: 'Material Icons';
            font-weight: normal;
            font-style: normal;
            display: inline-block;
            line-height: 1;
            text-transform: none;
            letter-spacing: normal;
            word-wrap: normal;
            white-space: nowrap;
            direction: ltr;

            /* Support for all WebKit browsers. */
            -webkit-font-smoothing: antialiased;
            /* Support for Safari and Chrome. */
            text-rendering: optimizeLegibility;

            /* Support for Firefox. */
            -moz-osx-font-smoothing: grayscale;

            /* Support for IE. */
            font-feature-settings: 'liga';
        }
    </style>
</head>
<body class="container">
    <div>
        <div>$(current_time)</div>
    </div>
    <div>
        <i class="material-icons">$(battery | battery_icon)</i>
        <div>$(battery | head -n 1)%</div>
    </div>
    <div>
        <i class="material-icons">$(volume | volume_icon)</i>
        <div>$(volume)%</div>
    </div>
</body>
</html>
EOF
