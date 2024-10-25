#!/usr/bin/bash

base_commit='offsets'

while getopts ':b:' opt; do
	case $opt in
		b)b="$OPTARG";;
		*);;
	esac
done

cd app
if [ -z $b ]; then b='release/full'; fi
git checkout $b

cd ..
rm -rf release/
mkdir release
cp steam/resources/app.bkp.asar release/app.asar

cd release
asar extract app.asar app/
js-beautify app/dist/electron/renderer.js > renderer.js

cd ..
diff -u release/renderer.js \
	<( sed 's/function __[0-9]\+/function/g' app/dist/electron/renderer.js ) > $b.patch

echo "Done"

