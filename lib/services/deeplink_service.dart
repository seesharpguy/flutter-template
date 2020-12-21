import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/services.dart';

class DeepLinkService {
  Future<String> initialGameId() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Uri initialLink = await getInitialUri();

      if (initialLink != null) {
        String gameId = initialLink.queryParameters['gameId'];
        return gameId;
      } else {
        return null;
      }

      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // TODO: log exceptions client side
      return null;
    }
  }

  Stream<Uri> uniLinks() {
    // Attach a listener to the stream
    return getUriLinksStream();
  }
}
