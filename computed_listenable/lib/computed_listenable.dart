import 'package:flutter/foundation.dart';

typedef ComputeListenable<T> = T Function(SignalContext context);

abstract interface class SignalContext {
  void listen(Listenable listenable);
  T watch<T>(ValueListenable<T> listenable);
}

class ComputedListenable<T> implements ValueListenable<T> {
  ComputedListenable(ComputeListenable<T> compute)
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
  _ComputedListenable(this._compute);

  final ComputeListenable<T> _compute;

  T? _cachedValue;
  bool _isDirty = true;
  bool _debugIsBuilding = false;

  Set<Listenable>? _listenables;
  Set<Listenable>? _newListenables;
  int _unchangedListenables = 0;

  T get value {
    ChangeNotifier.debugAssertNotDisposed(this);
    _rebuildIfNecessary();
    return _cachedValue as T;
  }

  void markDirty() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _isDirty = true;
    notifyListeners();
  }

  @override
  void listen(Listenable listenable) {
    assert(_debugCheckIsBuilding('listen'));
    ChangeNotifier.debugAssertNotDisposed(this);

    // Handle unchanged listenable.
    if (_listenables != null &&
        _newListenables != null &&
        _unchangedListenables < _listenables!.length &&
        identical(_listenables!.elementAt(_unchangedListenables), listenable)) {
      _unchangedListenables += 1;
      return;
    }

    // Handle new listenable.
    if (_newListenables == null) {
      _newListenables = <Listenable>{};
      for (int i = 0; i < _unchangedListenables; i++) {
        _newListenables!.add(_listenables!.elementAt(i));
      }
    }
    _newListenables!.add(listenable);
  }

  @override
  ValueType watch<ValueType>(ValueListenable<ValueType> valueListenable) {
    assert(_debugCheckIsBuilding('watch'));
    ChangeNotifier.debugAssertNotDisposed(this);
    listen(valueListenable);
    return valueListenable.value;
  }

  @override
  void dispose() {
    assert(_debugIsBuilding == false);

    if (_listenables != null) {
      for (final listenable in _listenables!) {
        listenable.removeListener(markDirty);
      }
      _listenables = null;
    }
    super.dispose();
  }

  bool _debugCheckIsBuilding(String methodName) {
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
  }

  void _rebuildIfNecessary() {
    assert(() {
      if (_debugIsBuilding) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('ComputedListenable is already being computed.'),
          ErrorDescription(
            'This can happen if a ComputedListenable tries to read its own '
            'value during its computation.',
          ),
        ]);
      }
      return true;
    }());
    
    if (!_isDirty) {
      return;
    }

    assert(_newListenables == null);
    assert(_unchangedListenables == 0);
    assert(() {
      _debugIsBuilding = true;
      return true;
    }());

    _cachedValue = _compute(this);
    _updateListenables();
    _isDirty = false;
    assert(() {
      _debugIsBuilding = false;
      return true;
    }());
  }
 
  void _updateListenables() {
    assert(_unchangedListenables <= (_listenables?.length ?? 0));
    final Set<Listenable>? oldListenables = _listenables;
    final Set<Listenable>? newListenables = _newListenables;
    final bool allOldListenablesUnchanged =
        _unchangedListenables == (oldListenables?.length ?? 0);
    if (allOldListenablesUnchanged && newListenables == null) {
      _unchangedListenables = 0;
      return;
    }

    if (oldListenables != null) {
      for (final Listenable listenable in oldListenables) {
        if (newListenables == null || !newListenables.contains(listenable)) {
          listenable.removeListener(markDirty);
        }
      }
    }

    if (newListenables != null) {
      for (final Listenable listenable in newListenables) {
        if (oldListenables == null || !oldListenables.contains(listenable)) {
          listenable.addListener(markDirty);
        }
      }
    }

    _listenables = newListenables;
    _newListenables = null;
    _unchangedListenables = 0;
  }
}
