import 'package:flutter/widgets.dart';

typedef CreateInheritedValueCallback<T> = T Function();
typedef UpdateShouldNotifyCallback<T> = bool Function(T oldValue, T newValue);

typedef CreateInheritedValuesCallback = void Function(InheritedValueRegistry registry);
typedef AddInheritedValueCallback = void Function<T>(T value);

// TODO: Add support for Disposable / AsyncDisposable values.
class InheritedValue<T> extends StatefulWidget {
  const InheritedValue({
    super.key,
    required this.create,
    this.onDispose,
    required this.child,
  });

  final CreateInheritedValueCallback<T> create;
  final VoidCallback? onDispose;
  final Widget child;

  static T? maybePeek<T>(BuildContext context) {
    return RawInheritedValue.maybePeek<T>(context);
  }

  static T peek<T>(BuildContext context) {
    return RawInheritedValue.peek<T>(context);
  }

  static T? maybeOf<T>(BuildContext context) {
    return RawInheritedValue.maybeOf<T>(context);
  }

  static T of<T>(BuildContext context) {
    return RawInheritedValue.of<T>(context);
  }

  @override
  State<InheritedValue<T>> createState() => _InheritedValueState<T>();
}

class _InheritedValueState<T> extends State<InheritedValue<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return RawInheritedValue<T>(
      value: value,
      updateShouldNotify: (T oldValue, T newValue) {
        assert(oldValue == newValue);
        return false;
      },
      onDispose: widget.onDispose,
      child: widget.child,
    );
  }
}

// TODO: Add support for Disposable / AsyncDisposable values.
class InheritedValueRegistry {
  final List<Widget Function(Widget)> _added = [];

  bool _debugBuilt = false;

  void add<T>(T value) {
    assert(_debugBuilt == false);
    _added.add((child) {
      return RawInheritedValue<T>(
        value: value,
        updateShouldNotify: (T oldValue, T newValue) {
          assert(oldValue == newValue);
          return false;
        },
        child: child,
      );
    });
  }

  Widget _build(Widget child) {
    assert(() {
      _debugBuilt = true;
      return true;
    }());

    var result = child;
    for (final wrapper in _added.reversed) {
      result = wrapper(result);
    }
    return result;
  }
}

class RawInheritedValue<T> extends StatefulWidget {
  const RawInheritedValue({
    super.key,
    required this.value,
    required this.updateShouldNotify,
    this.onDispose,
    required this.child,
  });

  final T value;
  final UpdateShouldNotifyCallback<T> updateShouldNotify;
  final VoidCallback? onDispose;
  final Widget child;

  static T? maybePeek<T>(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<_RawInheritedValue<T>>();
    return (element?.widget as _RawInheritedValue<T>?)?.value;
  }

  static T peek<T>(BuildContext context) {
    final value = maybePeek<T>(context);
    assert(value != null);
    return value!;
  }

  static T? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_RawInheritedValue<T>>()?.value;
  }

  static T of<T>(BuildContext context) {
    final value = maybeOf<T>(context);
    assert(value != null);
    return value!;
  }

  @override
  State<RawInheritedValue<T>> createState() => _RawInheritedValueState<T>();
}

class _RawInheritedValueState<T> extends State<RawInheritedValue<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(RawInheritedValue<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      value = widget.value!;
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RawInheritedValue<T>(
      value: value,
      updateShouldNotify: widget.updateShouldNotify,
      child: widget.child,
    );
  }
}

class _RawInheritedValue<T> extends InheritedWidget {
  const _RawInheritedValue({
    super.key,
    required this.value,
    required UpdateShouldNotifyCallback<T> updateShouldNotify,
    required super.child,
  }) : _updateShouldNotifyCallback = updateShouldNotify;

  final T value;
  final UpdateShouldNotifyCallback<T> _updateShouldNotifyCallback;

  @override
  bool updateShouldNotify(_RawInheritedValue<T> oldWidget) {
    return _updateShouldNotifyCallback(oldWidget.value, value);
  }
}

class InheritedValues extends StatefulWidget {
  const InheritedValues({
    super.key,
    required this.create,
    required this.child,
  });

  final CreateInheritedValuesCallback create;
  final Widget child;

  @override
  State<InheritedValues> createState() => _InheritedValuesState();
}

class _InheritedValuesState extends State<InheritedValues> {

  late final InheritedValueRegistry values;

  @override
  void initState() {
    super.initState();

    values = InheritedValueRegistry();
    widget.create(values);
  }

  @override
  Widget build(BuildContext context) => values._build(widget.child);
}
