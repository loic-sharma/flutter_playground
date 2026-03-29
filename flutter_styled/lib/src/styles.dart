import 'package:flutter/widgets.dart';

import 'optional_widgets.dart';
import 'styled.dart';

@immutable
abstract class Style {
  const Style();

  bool updateShouldRebuild(covariant Style oldStyle);

  Widget build(BuildContext context, bool enabled, Widget child);

  const factory Style.none() = NoneStyle;
  const factory Style.builder(StyleBuilder builder) = BuilderStyle;

  const factory Style.backgroundColor(Color color) = BackgroundColorStyle;
  const factory Style.center() = CenterStyle;
  const factory Style.clipRect({CustomClipper<Rect>? clipper, Clip clipBehavior}) = ClipRectStyle;
  const factory Style.clipRRect({BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip clipBehavior}) = ClipRRectStyle;
  const factory Style.expand() = ExpandStyle;
  const factory Style.height(double height) = HeightStyle;
  const factory Style.opacity(double opacity, {bool alwaysIncludeSemantics}) = OpacityStyle;
  const factory Style.padding(EdgeInsetsGeometry insets) = PaddingStyle;
  const factory Style.shrink() = ShrinkStyle;
  const factory Style.size({double? width, double? height}) = SizeStyle;
  const factory Style.textStyle({Color? color, double? fontSize}) = TextStyleStyle;
  const factory Style.transform({
    required Matrix4 transform,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Offset? origin,
  }) = TransformStyle;
  const factory Style.width(double width) = WidthStyle;

  const factory Style.when({required bool condition, List<Style>? thenStyle, List<Style>? elseStyle}) = WhenStyle;
  const factory Style.whenSmall(List<Style> styles) = WhenSmallStyle;
}

class NoneStyle extends Style {
  const NoneStyle();

  @override
  bool updateShouldRebuild(NoneStyle oldStyle) => false;

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return child;
  }
}

class BuilderStyle extends Style {
  const BuilderStyle(this.builder);

  final StyleBuilder builder;

  @override
  bool updateShouldRebuild(BuilderStyle oldStyle) {
    return builder != oldStyle.builder;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return builder(context, enabled, child);
  }
}

class BackgroundColorStyle extends Style {
  const BackgroundColorStyle(this.color);

  final Color color;

  @override
  bool updateShouldRebuild(BackgroundColorStyle oldStyle) {
    return color != oldStyle.color;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalColoredBox(
      enabled: enabled,
      color: color,
      child: child,
    );
  }
}

class CenterStyle extends Style {
  const CenterStyle();

  @override
  bool updateShouldRebuild(CenterStyle oldStyle) {
    return false;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalCenter(
      enabled: enabled,
      child: child,
    );
  }
}

class PaddingStyle extends Style {
  const PaddingStyle(this.insets);

  final EdgeInsetsGeometry insets;

  @override
  bool updateShouldRebuild(PaddingStyle oldStyle) {
    return insets != oldStyle.insets;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalPadding(
      enabled: enabled,
      padding: insets,
      child: child,
    );
  }
}

class TextStyleStyle extends Style {
  const TextStyleStyle({this.color, this.fontSize});

  final Color? color;
  final double? fontSize;

  TextStyle get style {
    return TextStyle(
      color: color,
      fontSize: fontSize,
    );
  }

  @override
  bool updateShouldRebuild(TextStyleStyle oldStyle) {
    return style != oldStyle.style;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalDefaultTextStyle(
      enabled: enabled,
      style: style,
      child: child,
    );
  }
}

class WhenStyle extends Style {
  const WhenStyle({
    required this.condition,
    this.thenStyle,
    this.elseStyle
  });

  final bool condition;
  final List<Style>? thenStyle;
  final List<Style>? elseStyle;

  @override
  bool updateShouldRebuild(WhenStyle oldStyle) {
    return condition != oldStyle.condition || thenStyle != oldStyle.thenStyle || elseStyle != oldStyle.elseStyle;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return Styled(
      styles: thenStyle ?? const [],
      enabled: enabled && condition,
      child: Styled(
        styles: elseStyle ?? const [],
        enabled: enabled && !condition,
        child: child,
      ),
    );
  }
}

class WhenSmallStyle extends Style {
  const WhenSmallStyle(this.styles);

  final List<Style> styles;

  @override
  bool updateShouldRebuild(WhenSmallStyle oldStyle) {
    return styles != oldStyle.styles;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return LayoutBuilder(builder: (context, constraints) {
      // TODO: Use inherited widget for breakpoints
      bool isSmall = constraints.maxWidth < 400;
      return Styled(
        styles: styles,
        enabled: enabled && isSmall,
        child: child,
      );
    });
  }
}

class ExpandStyle extends Style {
  const ExpandStyle();

  @override
  bool updateShouldRebuild(covariant Style oldStyle) => false;

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalSizedBox.expand(enabled: enabled, child: child);
  }
}

class HeightStyle extends Style {
  const HeightStyle(this.height);

  final double height;

  @override
  bool updateShouldRebuild(covariant HeightStyle oldStyle) {
    return height != oldStyle.height;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalSizedBox(
      enabled: enabled,
      height: height,
      child: child,
    );
  }
}

class OpacityStyle extends Style {
  const OpacityStyle(
    this.opacity, {
    this.alwaysIncludeSemantics = false,
  });

  final double opacity;
  final bool alwaysIncludeSemantics;

  @override
  bool updateShouldRebuild(OpacityStyle oldStyle) {
    return opacity != oldStyle.opacity || alwaysIncludeSemantics != oldStyle.alwaysIncludeSemantics;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return Opacity(
      opacity: enabled ? opacity : 1.0,
      child: child,
    );
  }
}

class ClipRectStyle extends Style {
  const ClipRectStyle({
    this.clipper,
    this.clipBehavior = Clip.hardEdge,
  });

  final CustomClipper<Rect>? clipper;
  final Clip clipBehavior;

  @override
  bool updateShouldRebuild(ClipRectStyle oldStyle) {
    return clipper != oldStyle.clipper || clipBehavior != oldStyle.clipBehavior;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return ClipRect(
      clipper: enabled ? clipper : null,
      clipBehavior: enabled ? clipBehavior : Clip.none,
      child: child,
    );
  }
}

class ClipRRectStyle extends Style {
  const ClipRRectStyle({
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
  });

  final BorderRadius borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;

  @override
  bool updateShouldRebuild(ClipRRectStyle oldStyle) {
    return borderRadius != oldStyle.borderRadius || clipper != oldStyle.clipper || clipBehavior != oldStyle.clipBehavior;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return ClipRRect(
      borderRadius: enabled ? borderRadius : BorderRadius.zero,
      clipper: clipper,
      clipBehavior: enabled ? clipBehavior : Clip.none,
      child: child,
    );
  }
}

class ShrinkStyle extends Style {
  const ShrinkStyle();

  @override
  bool updateShouldRebuild(covariant Style oldStyle) => false;

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalSizedBox.shrink(enabled: enabled, child: child);
  }
}

class SizeStyle extends Style {
  const SizeStyle({this.width, this.height});

  final double? width;
  final double? height;

  @override
  bool updateShouldRebuild(SizeStyle oldStyle) {
    return width != oldStyle.width || height != oldStyle.height;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalSizedBox(
      enabled: enabled,
      width: width,
      height: height,
      child: child,
    );
  }
}

class TransformStyle extends Style {
  const TransformStyle({
    required this.transform,
    this.alignment,
    this.transformHitTests = true,
    this.filterQuality,
    this.origin,
  });

  final Matrix4 transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  final FilterQuality? filterQuality;

  @override
  bool updateShouldRebuild(TransformStyle oldStyle) {
    return transform != oldStyle.transform ||
        origin != oldStyle.origin ||
        alignment != oldStyle.alignment ||
        transformHitTests != oldStyle.transformHitTests ||
        filterQuality != oldStyle.filterQuality;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
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

class WidthStyle extends Style {
  const WidthStyle(this.width);

  final double width;

  @override
  bool updateShouldRebuild(covariant WidthStyle oldStyle) {
    return width != oldStyle.width;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    return OptionalSizedBox(
      enabled: enabled,
      width: width,
      child: child,
    );
  }
}