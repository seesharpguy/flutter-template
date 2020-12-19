clean:
	flutter clean
	flutter pub get

upgrade:
	flutter packages upgrade

icon:
	flutter pub get
	flutter pub run flutter_launcher_icons:main

keystore:
	keytool -genkey -v -keystore ~/jibekey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias jibekey

bundle:
	flutter build appbundle

apk:
	flutter build apk --split-per-abi --no-shrink

install: clean apk
	flutter install