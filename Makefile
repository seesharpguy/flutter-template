clean:
	flutter clean
	flutter pub get

upgrade:
	flutter packages upgrade

icon:
	flutter pub get
	flutter pub run flutter_launcher_icons:main

generate-keystore:
	keytool -genkey -v -keystore ~/APPLICATION_NAMEkey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias APPLICATION_NAMEkey

list-keystore:
	keytool -list -v -alias APPLICATION_NAMEkey -keystore ~/APPLICATION_NAMEkey.jks

bundle:
	flutter build appbundle

archive:
	flutter build ipa

apk:
	flutter build apk --split-per-abi

build-ios:
	flutter build ios

install-android: clean apk
	flutter install

install-ios: clean build-ios
	flutter install