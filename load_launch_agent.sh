#!/usr/bin/env bash
# Run Jupyter Notebook as a service on macOS
# Based on https://gist.github.com/nathanielobrown/1614c1011d8eb5aad291fda7c60c5563

COMMAND=${1:-notebook}
PORT=${2:-8888}

LABEL=org.jupyter.$COMMAND.$(whoami)
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG="$HOME/Library/Logs/$LABEL.log"

echo Writing $PLIST

# TODO: Password? Might be better to set independently
# See https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>$LABEL</string>

        <key>ProgramArguments</key>
        <array>
            <string>$(which jupyter)</string>
            <string>$COMMAND</string>
            <string>--no-browser</string>
            <string>--port</string>
            <string>$PORT</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

        <key>KeepAlive</key>
        <true/>

        <key>WorkingDirectory</key>
        <string>$HOME</string>

        <key>StandardOutPath</key>
        <string>$LOG</string>

        <key>StandardErrorPath</key>
        <string>$LOG</string>
    </dict>
</plist>
EOF

if launchctl list | grep -q $LABEL; then
    echo Unloading $LABEL
    launchctl unload "$PLIST"
fi

echo Loading $LABEL
launchctl load "$PLIST"

echo Logging to $LOG
while ! [ -f $LOG ]; do
    sleep 1
done

tail -n 20 -f $LOG
