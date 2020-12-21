# jibe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## commands

## flutter clean and pub get

```js
make clean
```

## upgrade dependencies

```node
make upgrade
```

## generate icons

```node
make icon
```

## generate keystore

```node
make keystore
```

## generate bundle

```node
make bundle
```

## generate apk

```node
make apk
```

## debug apk

```node
adb -d logcat
```

Images

<!-- <span>Photo by <a href="https://unsplash.com/@enginakyurt?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">engin akyurt</a> on <a href="https://unsplash.com/s/photos/thumbs-up?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span> -->

## test with link

```node
adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "grateful8games://jibe/game/join?gameId=ABCDEF11"'
```