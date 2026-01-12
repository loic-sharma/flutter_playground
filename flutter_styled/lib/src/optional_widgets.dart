import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled/src/optionally_wrapped_box.dart';

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

class OptionalCenter extends OptionalAlign {
  const OptionalCenter({super.key, super.enabled, super.widthFactor, super.heightFactor, super.child});
}

class OptionalAlign extends OptionallyWrappedChildWidget {
  const OptionalAlign({
    super.key,
    super.enabled,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    super.child,
  }) : assert(widthFactor == null || widthFactor >= 0.0),
       assert(heightFactor == null || heightFactor >= 0.0);

  final AlignmentGeometry alignment;

  final double? widthFactor;

  final double? heightFactor;

  @override
  RenderPositionedBox createWrapperRenderBox(BuildContext context) {
    return RenderPositionedBox(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateWrapperRenderBox(BuildContext context, RenderPositionedBox renderObject) {
    renderObject
      ..alignment = alignment
      ..widthFactor = widthFactor
      ..heightFactor = heightFactor
      ..textDirection = Directionality.maybeOf(context);
  }
}
