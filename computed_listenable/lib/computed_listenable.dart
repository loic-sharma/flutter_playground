import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ComputeCallback<T> = T Function(SignalContext context);

abstract interface class SignalContext {
  /// Registers this context to listen to the given [Listenable] until the next rebuild.
  ///
  /// This context will rebuild if the [Listenable] notifies its listeners.
  ///
  /// If the next rebuild does not call this method again with the same [Listenable],
  /// this context will stop listening to the [Listenable].
  void listen(Listenable listenable);

  /// Registers this context to watch the given [ValueListenable] until the next rebuild.
  ///
  /// This context will rebuild if the [ValueListenable]'s value changes.
  ///
  /// If the next rebuild does not call this method again with the same [ValueListenable],
  /// this context will stop listening to the [ValueListenable].
  T watch<T>(ValueListenable<T> listenable);
}

class ComputedListenable<T> implements ValueListenable<T> {
  ComputedListenable(ComputeCallback<T> compute)
    : _inner = _ComputedListenable<T>(compute);

  final _ComputedListenable<T> _inner;

  @override
  T get value => _inner.value;

  @override
  void addListener(VoidCallback listener) {
    _inner.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _inner.removeListener(listener);
  }

  void dispose() {
    _inner.dispose();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class _ComputedListenable<T> extends ChangeNotifier implements SignalContext {
  _ComputedListenable(this._compute) {
    _build();
  }

  final ComputeCallback<T> _compute;

  T? _value;
  bool _debugIsBuilding = false;

  /// The listenables that were listened to during the last build.
  ///
  /// This is null if has not been built yet, or if no
  /// listenables were listened to during the last build.
  List<Listenable>? _listenables;

  /// New listenables added during the current build.
  ///
  /// This is null outside of a build, or if the current build has not changed
  /// listenables yet.
  List<Listenable>? _newListenables;

  /// During a build, the index of the last unchanged listenable in [_listenables].
  ///
  /// This is used to optimize the case where the listenables do not change between builds.
  /// This value is 0 outside of a build, and is reset to 0 at the start of each build.
  int _unchangedListenables = 0;

  T get value {
    ChangeNotifier.debugAssertNotDisposed(this);
    return _value as T;
  }

  @override
  void dispose() {
    assert(_debugIsBuilding == false);

    if (_listenables != null) {
      for (final listenable in _listenables!) {
        listenable.removeListener(_build);
      }
      _listenables = null;
    }
    super.dispose();
  }

  @override
  void listen(Listenable listenable) {
    ChangeNotifier.debugAssertNotDisposed(this);
    _debugAssertIsBuilding('listen');

    // Handle unchanged listenable.
    if (_listenables != null &&
        _newListenables == null &&
        _unchangedListenables < _listenables!.length &&
        identical(_listenables!.elementAt(_unchangedListenables), listenable)) {
      _unchangedListenables += 1;
      return;
    }

    // Handle new listenable.
    if (_newListenables == null) {
      _newListenables = <Listenable>[];
      for (int i = 0; i < _unchangedListenables; i++) {
        _newListenables!.add(_listenables!.elementAt(i));
      }
    }

    _newListenables!.add(listenable);
  }

  @override
  ValueType watch<ValueType>(ValueListenable<ValueType> valueListenable) {
    ChangeNotifier.debugAssertNotDisposed(this);
    _debugAssertIsBuilding('watch');
    listen(valueListenable);
    return valueListenable.value;
  }

  void _build() {
    ChangeNotifier.debugAssertNotDisposed(this);
    assert(() {
      if (_debugIsBuilding) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('ComputedListenable is already being computed.'),
          ErrorDescription(
            "This can happen if a ComputedListenable's computation updates a Listenable it listens to.",
          ),
        ]);
      }
      return true;
    }());

    assert(_newListenables == null);
    assert(_unchangedListenables == 0);
    assert(() {
      _debugIsBuilding = true;
      return true;
    }());

    var updated = false;
    try {
      var value = _compute(this);
      if (_value != value) {
        _value = value;
        updated = true;
      }
    }
    catch (exception, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: exception,
        stack: stack,
        library: 'computed_listenable',
        context: ErrorDescription('while computing a ComputedListenable'),
      ));
    }

    _updateListenables();

    assert(_newListenables == null);
    assert(_unchangedListenables == 0);
    assert(() {
      _debugIsBuilding = false;
      return true;
    }());

    if (updated) {
      notifyListeners();
    }
  }
 
  void _updateListenables() {
    assert(_debugIsBuilding);
    assert(_unchangedListenables <= (_listenables?.length ?? 0));
    assert(_newListenables == null || _unchangedListenables <= _newListenables!.length);

    // Remove old listeners if needed.
    if (_listenables != null) {
      for (var i = _unchangedListenables; i < _listenables!.length; i++) {
        _listenables![i].removeListener(_build);
      }

      // If the listenables list has shrunk, we need to remove the old listenables from the list.
      if (_newListenables == null && _unchangedListenables < _listenables!.length) {
        _listenables = _listenables!.sublist(0, _unchangedListenables);
      }
    }

    // Add new listeners if needed.
    if (_newListenables != null) {
      for (var i = _unchangedListenables; i < _newListenables!.length; i++) {
        _newListenables![i].addListener(_build);
      }

      _listenables = _newListenables;
      _newListenables = null;
    }

    _unchangedListenables = 0;
  }

  void _debugAssertIsBuilding(String methodName) {
    assert(() {
      if (!_debugIsBuilding) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'ComputedListenable.$methodName() called outside of a computed context.',
          ),
          ErrorDescription(
            'ComputedListenable.$methodName() can only be called while computing '
            'the value of a ComputedListenable.',
          ),
        ]);
      }
      return true;
    }());
  }
}

class ComputedBuilder<T> extends StatefulWidget {
  const ComputedBuilder({super.key, required this.computed, required this.builder, this.child});

  final ComputeCallback<T> computed;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<ComputedBuilder<T>> createState() => _ComputedBuilderState<T>();
}

class _ComputedBuilderState<T> extends State<ComputedBuilder<T>> {
  late ComputedListenable<T> _computed;

  @override
  void initState() {
    super.initState();
    _computed = ComputedListenable<T>(widget.computed);
    _computed.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(ComputedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.computed != widget.computed) {
      _computed.removeListener(_handleChange);
      _computed.dispose();
      _computed = ComputedListenable<T>(widget.computed);
      _computed.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    _computed.removeListener(_handleChange);
    _computed.dispose();
    super.dispose();
  }

  void _handleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _computed.value, widget.child);
  }
}
