#!/bin/zsh

is_mac()     { [[ $OSTYPE == darwin*   ]] }

PROFILE_PATH=$1

if [[ -z "$PROFILE_PATH" ]]; then
    echo "PROFILE PATH is not provided. Get it from about:profiles"
    exit 1;
fi

curl 'https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js' | cat - firefox/user.js > $PROFILE_PATH/user.js

if [[ -h "$PROFILE_PATH/chrome" ]]; then
    echo "chrome symlink already exists. Skipping this step"
else
    ln -s "$PWD/firefox/chrome" "$PROFILE_PATH/chrome"
fi

if is_mac; then
    defaults delete ~/Library/Preferences/org.mozilla.firefox
    cat firefox/policies.json | jq '.policies' | plutil -convert xml1 - -o out.plist
    defaults import ~/Library/Preferences/org.mozilla.firefox out.plist
    rm out.plist
    exit 0;
fi

# TODO(a.eremeev): make distribution agnostic
DISTRIBUTION_PATH="/usr/lib/firefox/distribution"
echo "$DISTRIBUTION_PATH"
if [[ -h "$DISTRIBUTION_PATH/policies.json" ]]; then
    echo "policies.json already exists. Skipping this step"
else
    sudo ln -s "$PWD/firefox/policies.json" "$DISTRIBUTION_PATH/policies.json"
fi
