import 'package:flutter/widgets.dart';

typedef CreateInheritedValueCallback<T> = T Function();
typedef UpdateShouldNotifyCallback<T> = bool Function(T oldValue, T newValue);

typedef CreateInheritedValuesCallback = void Function(InheritedValueRegistry registry);
typedef AddInheritedValueCallback = void Function<T>(T value);

class InheritedValue<T> extends StatefulWidget {
  const InheritedValue({
    Key? key,
    required CreateInheritedValueCallback<T> create,
    required Widget child,
  }) : this._(key: key, create: create, child: child);

  const InheritedValue.value({
    Key? key,
    required T value,
    required UpdateShouldNotifyCallback<T> updateShouldNotify,
    required Widget child,
  }) : this._(key: key, value: value, updateShouldNotify: updateShouldNotify, child: child);

  const InheritedValue._({
    super.key,
    this.value,
    this.create,
    this.updateShouldNotify,
    required this.child,
  }) : assert(value != null || create != null),
       assert((value == null) == (updateShouldNotify == null));

  final T? value;
  final CreateInheritedValueCallback<T>? create;
  final UpdateShouldNotifyCallback<T>? updateShouldNotify;
  final Widget child;

  static T of<T>(BuildContext context) {
    return _RawInheritedValue.of<T>(context);
  }

  @override
  State<InheritedValue<T>> createState() => _InheritedValueState<T>();
}

class _InheritedValueState<T> extends State<InheritedValue<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.value ?? widget.create!();
  }

  @override
  void didUpdateWidget(covariant InheritedValue<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      value = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RawInheritedValue<T>(
      value: value!,
      updateShouldNotify: widget.updateShouldNotify ?? _defaultUpdateShouldNotify,
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

  static T? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_RawInheritedValue<T>>()?.value;
  }

  static T of<T>(BuildContext context) {
    final value = maybeOf<T>(context);
    assert(value != null);
    return value!;
  }

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

class InheritedValueRegistry {
  final List<Widget Function(Widget)> _added = [];

  bool _debugBuilt = false;

  void add<T>(T value) {
    assert(_debugBuilt == false);
    _added.add((child) {
      return InheritedValue<T>.value(
        value: value,
        updateShouldNotify: _defaultUpdateShouldNotify,
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

  bool _defaultUpdateShouldNotify<T>(T oldValue, T newValue) {
    return oldValue != newValue;
  }
