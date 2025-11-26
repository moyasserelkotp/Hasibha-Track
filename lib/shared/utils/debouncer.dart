import 'dart:async';

/// Debouncer utility for search and other inputs
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 500)});

  /// Call the action after debounce duration
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancel pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler utility for rate limiting
class Throttler {
  final Duration duration;
  Timer? _timer;
  bool _isReady = true;

  Throttler({this.duration = const Duration(milliseconds: 300)});

  /// Call the action only if ready (throttled)
  void call(void Function() action) {
    if (_isReady) {
      _isReady = false;
      action();
      _timer = Timer(duration, () {
        _isReady = true;
      });
    }
  }

  /// Dispose throttler
  void dispose() {
    _timer?.cancel();
  }
}

/// Extension on Stream for debouncing
extension StreamDebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    return transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          Timer? timer;
          timer?.cancel();
          timer = Timer(duration, () {
            sink.add(data);
          });
        },
      ),
    );
  }
}
