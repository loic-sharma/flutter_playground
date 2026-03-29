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
  final Map<Style, Widget> _cachedWidgets = {};

  @override
  void didUpdateWidget(Styled oldWidget) {
    _updateCachedWidgets(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _cachedWidgets.clear();
    super.didChangeDependencies();
  }

  void _updateCachedWidgets(Styled oldWidget) {
    // If child or enabled changed, all cached data is invalid.
    if (oldWidget.child != widget.child || oldWidget.enabled != widget.enabled) {
      _cachedWidgets.clear();
      return;
    }

    // Styles list changed, clear all cache.
    // TODO: We can do better here. We can walk through the
    // styles in reverse and reuse widgets that are unchanged.
    if (oldWidget.styles.length != widget.styles.length) {
      _cachedWidgets.clear();
      return;
    }

    bool subtreeChanged = false;
    for (var i = widget.styles.length - 1; i >= 0; i--) {
      final style = widget.styles[i];
      final oldStyle = oldWidget.styles[i];

      if (subtreeChanged) {
        _cachedWidgets.remove(oldStyle);
        continue;
      }

      if (style == oldStyle) {
        continue;
      }

      // If the style types are different, we cannot reuse
      // any cached widgets beyond this point.
      if (style.runtimeType != oldStyle.runtimeType) {
        subtreeChanged = true;
        _cachedWidgets.remove(oldStyle);
        continue;
      }

      // If the style changed, we cannot reuse any
      // cached widgets beyond this point.
      if (style.updateShouldRebuild(oldStyle)) {
        subtreeChanged = true;
        _cachedWidgets.remove(oldStyle);
        continue;
      }

      // Style is unchanged, update the cache and continue.
      _cachedWidgets[style] = _cachedWidgets[oldStyle]!;
      _cachedWidgets.remove(oldStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    var result = widget.child ?? const SizedBox.shrink();

    for (final style in widget.styles.reversed) {
      if (_cachedWidgets.containsKey(style)) {
        result = _cachedWidgets[style]!;
        continue;
      }

      result = style.build(context, widget.enabled, result);
      _cachedWidgets[style] = result;
    }

    return result;
  }
}

typedef StyleBuilder = Widget Function(
  BuildContext context,
  bool enabled,
  Widget child,
);
