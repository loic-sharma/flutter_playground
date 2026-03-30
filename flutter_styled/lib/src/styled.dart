import 'package:flutter/widgets.dart';

import 'styles.dart';

class Styled extends StatefulWidget {
  const Styled({
    super.key,
    this.enabled = true,
    required this.styles,
    this.child,
  });

  final bool enabled;
  final List<Style> styles;
  final Widget? child;

  @override
  State<Styled> createState() => _StyledState();
}

class _StyledState extends State<Styled> {
  Widget? _cachedWidget;

  @override
  void didUpdateWidget(Styled oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.styles != widget.styles
      || oldWidget.enabled != widget.enabled
      || oldWidget.child != widget.child) {
      _cachedWidget = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cachedWidget = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedWidget != null) {
      return _cachedWidget!;
    }

    var result = widget.child ?? const SizedBox.shrink();

    for (final style in widget.styles.reversed) {
      result = style.build(context, widget.enabled, result);
    }

    _cachedWidget = result;
    return result;
  }
}

typedef StyleBuilder = Widget Function(
  BuildContext context,
  bool enabled,
  Widget child,
);
