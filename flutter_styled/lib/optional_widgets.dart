import 'package:flutter/widgets.dart';

class OptionalColoredBox extends StatelessWidget {
  const OptionalColoredBox({
    super.key,
    required this.enabled,
    required this.color,
    required this.child,
  });

  final bool enabled;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: enabled ? color : Color(0x00000000),
      child: child,
    );
  }
}

class OptionalPadding extends StatelessWidget {
  const OptionalPadding({
    super.key,
    required this.enabled,
    required this.padding,
    required this.child,
  });

  final bool enabled;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: enabled ? padding : EdgeInsets.zero,
      child: child,
    );
  }
}

class OptionalDefaultTextStyle extends StatelessWidget {
  const OptionalDefaultTextStyle({
    super.key,
    required this.enabled,
    required this.style,
    required this.child,
  });

  final bool enabled;
  final TextStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: enabled ? style : const TextStyle(),
      child: child,
    );
  }
}

class OptionalCenter extends StatelessWidget {
  const OptionalCenter({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO
    assert(enabled, 'TODO: implement disabled Center');
    return Center(
      child: child,
    );
  }
}
