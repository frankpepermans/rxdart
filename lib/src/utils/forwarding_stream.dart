import 'dart:async';

import 'package:rxdart/src/utils/forwarding_sink.dart';

/// @private
/// Helper method which forwards the events from an incoming [Stream]
/// to a new [StreamController].
/// It captures events such as onListen, onPause, onResume and onCancel,
/// which can be used in pair with a [ForwardingSink]
_ForwardStream<T> forwardStream<T>(Stream<T> stream) {
  StreamController<T> controller;
  ForwardingSink<T> connectedSink;

  final onListen = () {
    stream.listen(controller.add,
        onError: controller.addError, onDone: controller.close);

    connectedSink?.onListen();
  };

  final onCancel = () {
    connectedSink?.onCancel();
  };

  final onPause = () {
    connectedSink?.onPause();
  };

  final onResume = () {
    connectedSink?.onResume();
  };

  controller = stream.isBroadcast
      ? StreamController<T>.broadcast(
          onListen: onListen, onCancel: onCancel, sync: true)
      : StreamController<T>(
          onListen: onListen,
          onCancel: onCancel,
          onPause: onPause,
          onResume: onResume,
          sync: true);

  return _ForwardStream<T>(
      controller.stream, (ForwardingSink<T> sink) => connectedSink = sink);
}

class _ForwardStream<T> {
  final Stream<T> stream;
  final ForwardingSink<T> Function(ForwardingSink<T> sink) connect;

  _ForwardStream(this.stream, this.connect);
}
