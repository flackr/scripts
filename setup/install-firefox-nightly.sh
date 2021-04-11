#!/usr/bin/env bash

mkdir -p work
pushd work
rm -rf firefox || exit 1
curl -L "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-CA" | tar xjv || exit 1
mkdir -p ~/Downloads || exit 1
mv firefox ~/Downloads/firefox-nightly || exit 1
mkdir -p ~/.local/share/applications || exit 1

# Install icons
ls ~/Downloads/firefox-nightly/browser/chrome/icons/default/default*.png | while read
ICON; do
  SIZE=`echo "$ICON"|sed 's/^.*\/default\([0-9]*\)\.png$/\1/g'`
  mkdir -p ~/.local/share/icons/hicolor/${SIZE}x${SIZE}/apps || exit 1
  ln -s "$ICON" ~/.local/share/icons/hicolor/${SIZE}x${SIZE}/apps/firefox-nightly.png || exit 1
done

cat > ~/.local/share/applications/firefox-nightly.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox Nightly
GenericName=Web Browser
Comment=Access the Internet
Exec=${HOME}/Downloads/firefox-nightly/firefox %U
StartupNotify=true
Terminal=false
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/ftp;x-scheme-handler/http;x-scheme-handler/https;
EOF
popd
