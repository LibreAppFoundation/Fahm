# Trigger a build
cd ..
npm run build
cd app

# Clear current files
rm -rf www/static www/index.html

# Copy sources
cp -r ../dist/* www/
rm www/static/css/*.map
rm www/static/js/*.map

# Replace
sed -i 's/\/static/.\/static/g' www/index.html
sed -i 's/\/static\/img/\.\.\/img/g' www/static/css/app*.css
sed -ri 's/i\.p\+\"static/\"static/g' www/static/js/app*.js

export ANDROID_HOME=/home/niyasc/Development
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$PATH:/home/niyasc/.gradle/wrapper/dists/gradle-4.1-all/bzyivzo6n839fup2jbap0tjew/gradle-4.1/bin
export PATH=$PATH:/home/niyasc/Development/tools
export PATH=$PATH:/home/niyasc/Development/platform-tools
trap interrupted INT
function interrupted () {
    rm -f platforms/android/release.properties
}

stty -echo
read -p "Store Password: " spassw; echo
read -p "Key Password: " kpassw; echo
stty echo

cat << EOT > platforms/android/release.properties
storeFile=../../appkey.keystore
storePassword=$spassw
keyAlias=appkey
keyPassword=$spassw
EOT

export ORG_GRADLE_PROJECT_cdvReleaseSigningPropertiesFile=../release.properties 
cordova build --release android
rm platforms/android/release.properties

echo "Build completed, trying to kill java daeomon"
pkill java
