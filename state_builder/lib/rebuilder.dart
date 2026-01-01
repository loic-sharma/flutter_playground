import 'package:flutter/widgets.dart';

typedef RebuilderCallback<T> = Widget Function(BuildContext context, VoidCallback markNeedsBuild);

// This replaces StatefulBuilder:
// https://api.flutter.dev/flutter/widgets/StatefulBuilder-class.html
class Rebuilder extends StatefulWidget {
   const Rebuilder({
     super.key,
     required this.builder,
   });

  final RebuilderCallback builder;

  @override
  State<Rebuilder> createState() => _RebuilderState();
}

class _RebuilderState extends State<Rebuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, () => setState(() {}));
  }
}
