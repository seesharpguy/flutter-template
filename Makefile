clean:
	flutter clean
	flutter pub get

upgrade:
	flutter packages upgrade

icon:
	flutter pub get
	flutter pub run flutter_launcher_icons:main

generate-keystore:
	keytool -genkey -v -keystore ~/jibekey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias jibekey

list-keystore:
	keytool -list -v -alias jibekey -keystore ~/jibekey.jks

bundle:
	flutter build appbundle

apk:
	flutter build apk --split-per-abi --no-shrink

install: clean apk
	flutter install