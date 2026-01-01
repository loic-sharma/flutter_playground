import 'package:flutter/widgets.dart';

import 'optional_widgets.dart';

class Styled extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var result = child ?? const SizedBox.shrink();

    for (final style in styles.reversed) {
      result = style.build(context, enabled, result);
    }

    return result;
  }
}

typedef StyleBuilder = Widget Function(
  BuildContext context,
  bool enabled,
  Widget child,
);

abstract class Style {
  const Style();

  bool updateShouldRebuild(covariant Style oldStyle);

  Widget build(BuildContext context, bool enabled, Widget child);

  const factory Style.none() = NoneStyle;
  const factory Style.builder(StyleBuilder builder) = BuilderStyle;

  const factory Style.backgroundColor(Color color) = BackgroundColorStyle;
  const factory Style.center() = CenterStyle;
  const factory Style.padding(EdgeInsetsGeometry insets) = PaddingStyle;
  const factory Style.textStyle({Color? color, double? fontSize}) = TextStyleStyle;

  const factory Style.onHover(List<Style> styles) = HoverStyle;
  const factory Style.onSmall(List<Style> styles) = SmallScreenStyle;
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

class IfStyle extends Style {
  const IfStyle({
    required this.condition,
    required this.style,
    this.elseStyle
  });

  final bool condition;
  final Style style;
  final Style? elseStyle;

  @override
  bool updateShouldRebuild(IfStyle oldStyle) {
    return condition != oldStyle.condition || style != oldStyle.style;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    final elseStyle = this.elseStyle ?? const NoneStyle();

    Widget result = child;
    result = elseStyle.build(context, enabled && !condition, result);
    result = style.build(context, enabled && condition, result);
    return result;
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

class HoverStyle extends Style {
  const HoverStyle(this.styles);

  final List<Style> styles;

  @override
  bool updateShouldRebuild(HoverStyle oldStyle) {
    return styles != oldStyle.styles;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    // TODO: This API doesn't exist. The idea is this looks up the hover state
    // of the current "control" from the context.
    bool isHovered = WidgetStateContext.isHoveredOf(context);

    return Styled(
      styles: styles,
      enabled: enabled && isHovered,
      child: child,
    );
  }
}

class SmallScreenStyle extends Style {
  const SmallScreenStyle(this.styles);

  final List<Style> styles;

  @override
  bool updateShouldRebuild(SmallScreenStyle oldStyle) {
    return styles != oldStyle.styles;
  }

  @override
  Widget build(BuildContext context, bool enabled, Widget child) {
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Styled(
      styles: styles,
      enabled: enabled && isSmall,
      child: child,
    );
  }
}

class WidgetStateContext {
  static bool isHoveredOf(BuildContext context) => false;
}
