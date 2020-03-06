import 'dart:async';

/// A [Sink] that supports event hooks.
///
/// This makes it suitable for certain rx transformers that need to
/// take action after onListen, onPause, onResume or onCancel.
///
/// The [ForwardingSink] has been designed to handle asynchronous events from
/// [Stream]s. See, for example, [Stream.eventTransformed] which uses
/// `EventSink`s to transform events.
abstract class ForwardingSink<T> implements EventSink<T> {
  /// Fires when a listener subscribes on the underlying [Stream].
  void onListen();

  /// Fires when a subscriber pauses.
  void onPause();

  /// Fires when a subscriber resumes after a pause.
  void onResume();

  /// Fires when a subscriber cancels.
  void onCancel();
}
