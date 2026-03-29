import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'optionally_wrapped_box.dart';

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

class OptionalOpacity extends StatelessWidget {
  const OptionalOpacity({
    super.key,
    required this.enabled,
    required this.opacity,
    this.alwaysIncludeSemantics = false,
    required this.child,
  });

  final bool enabled;
  final double opacity;
  final bool alwaysIncludeSemantics;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? opacity : 1.0,
      child: child,
    );
  }
}

class OptionalClipRect extends StatelessWidget {
  const OptionalClipRect({
    super.key,
    required this.enabled,
    this.clipper,
    this.clipBehavior = Clip.hardEdge,
    required this.child,
  });

  final bool enabled;
  final CustomClipper<Rect>? clipper;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: enabled ? clipper : null,
      clipBehavior: enabled ? clipBehavior : Clip.none,
      child: child,
    );
  }
}

class OptionalClipRRect extends StatelessWidget {
  const OptionalClipRRect({
    super.key,
    required this.enabled,
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    required this.child,
  });

  final bool enabled;
  final BorderRadius borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: enabled ? borderRadius : BorderRadius.zero,
      clipper: clipper,
      clipBehavior: enabled ? clipBehavior : Clip.none,
      child: child,
    );
  }
}

class OptionalSizedBox extends StatelessWidget {
  const OptionalSizedBox({
    super.key,
    required this.enabled,
    this.width,
    this.height,
    required this.child,
  });

  const OptionalSizedBox.expand({
    super.key,
    required this.enabled,
    required this.child,
  }) : width = double.infinity, height = double.infinity;

  const OptionalSizedBox.shrink({
    super.key,
    required this.enabled,
    required this.child,
  }) : width = 0.0, height = 0.0;

  final bool enabled;
  final double? width;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: enabled ? width : null,
      height: enabled ? height : null,
      child: child,
    );
  }
}

class OptionalTransform extends StatelessWidget {
  const OptionalTransform({
    super.key,
    required this.enabled,
    required this.transform,
    this.alignment,
    this.transformHitTests = true,
    this.filterQuality,
    this.origin,
    required this.child,
  });

  final bool enabled;
  final Matrix4 transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  final FilterQuality? filterQuality;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: enabled ? transform : Matrix4.identity(),
      origin: enabled ? origin : null,
      alignment: enabled ? alignment : null,
      transformHitTests: enabled? transformHitTests : false,
      filterQuality: enabled ? filterQuality : null,
      child: child,
    );
  }
}
