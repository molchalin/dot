#!/bin/zsh

set -o errexit
set -o pipefail

is_mac()     { [[ $OSTYPE == darwin*   ]] }

PROFILE_PATH=$1

if [[ -z "$PROFILE_PATH" ]]; then
    echo "PROFILE PATH is not provided. Get it from about:profiles"
    exit 1;
fi

curl 'https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js' | cat - firefox/user.js > $PROFILE_PATH/user.js

if [[ -h "$PROFILE_PATH/chrome" ]]; then
    echo "chrome symlink already exists. Skipping this step"
elif [[ -d "$PROFILE_PATH/chrome" ]]; then
    echo "$PROFILE_PATH/chrome is a directory. Skipping this step"
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

DISTRIBUTION_PATHES=("/usr/lib/firefox/distribution", "/usr/lib64/firefox/distribution")

for e in "${DISTRIBUTION_PATHES[@]}"; do
    if [[ -e $e ]]; then
        DISTRIBUTION_PATH=$e
    fi
done
if [[ -z "$DISTRIBUTION_PATH" ]]; then
    echo "DISTRIBUTION PATH is not found"
    exit 1;
fi
if [[ -h "$DISTRIBUTION_PATH/policies.json" ]]; then
    echo "policies.json already exists. Skipping this step"
else
    sudo ln -s "$PWD/firefox/policies.json" "$DISTRIBUTION_PATH/policies.json"
fi
