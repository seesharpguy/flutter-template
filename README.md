# APPLICATION_NAME

A new Grateful8 Games project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Deployment Preparation](https://flutter.dev/docs/deployment/obfuscate)
- [Flutter Fire](https://firebase.flutter.dev/docs/overview)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## commands

## flutter clean and pub get

```js
make clean
```

## upgrade flutter dependencies

```js
make upgrade
```

## generate icons

> make platform icons (ios & android) from `./assets/launcher.png`

```js
make icon
```

## production keystore operations (android)

> list keystores

```js
make list-keystore
```

> make new kestore (.jks) file located at `~/APPLICATION_NAMEkey.jks`

```js
make keystore
```

## generate bundle

> create app bundle for distribution to android playstore

```js
make bundle
```

## generate apk

> create .apk for local installation to android device

```js
make apk
```

## debug apk

> debug running application on connected android device

```node
adb -d logcat
```

## test deep link

```node
adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "grateful8games://APPLICATION_NAME/game/join?gameId=ABCDEF11"'
```