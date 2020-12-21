import 'package:event/event.dart';

/// Represents some custom arguments provided to subscribers
/// when an [Event] occurs.
class ToastEventArgs extends EventArgs {
  String message;

  ToastEventArgs(this.message);
}
