import 'dart:async';

/// Behaves like a BehaviorSubject of rx_dart
/// emits the last value to the new listener
class StreamSubject<T> {
  late T _value;
  late StreamController<T> _controller;

  StreamSubject.seeded(T initialValue) {
    _value = initialValue;
    _controller = StreamController<T>.broadcast(
      sync: true,
      onListen: () => _controller.add(_value),
    );
  }

  Stream<T> get stream => _controller.stream;
  T get value => _value;

  void add(T data) {
    _value = data;
    _controller.add(data);
  }

  void close() {
    _controller.close();
  }
}

/// Makes an object observable
/// calls the listener when the value changes and passes the old and new value
class ObservableObject<T> {
  T _value;
  void Function(T oldValue, T newValue)? _onChange;

  ObservableObject({
    required T value,
    void Function(T oldValue, T newValue)? didSet,
  })  : _value = value,
        _onChange = didSet;

  T get value => _value;

  set value(T newValue) {
    final oldValue = _value;
    _value = newValue;
    _onChange?.call(oldValue, newValue);
  }

  void attachListener(void Function(T oldValue, T newValue) listener) {
    assert(_onChange == null, "onChange can be initialized only once");
    _onChange = listener;
  }

  void detachListener() {
    _onChange = null;
  }
}

extension XObject on Object {
  ObservableObject<T> asObservable<T>({
    void Function(T oldValue, T newValue)? didSet,
  }) {
    return ObservableObject<T>(
      value: this as T,
      didSet: didSet,
    );
  }
}
