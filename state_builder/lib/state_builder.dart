import 'package:flutter/widgets.dart';

typedef CreateStateCallback<T> = T Function(BuildContext context);
typedef StateBuilderCallback<T> = Widget Function(BuildContext context, T state, SetState<T> setState);
typedef SetState<T> = void Function(T newState);

// TODO: Add support for Disposable / AsyncDisposable states.
class StateBuilder<T> extends StatefulWidget {
  const StateBuilder({
    super.key,
    required this.create,
    this.onDispose,
    required this.builder,
  });

  final CreateStateCallback<T> create;
  final VoidCallback? onDispose;
  final StateBuilderCallback<T> builder;

  @override
  State<StateBuilder> createState() => _StateBuilderState<T>();
}

class _StateBuilderState<T> extends State<StateBuilder<T>> {
  late T state;

  @override
  void initState() {
    super.initState();
    state = widget.create(context);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      state,
      (T newState) {
        setState(() => state = newState);
      },
    );
  }
}
