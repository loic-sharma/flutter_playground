import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'component_box.dart';

class Container2 extends RenderComponentBoxWithChildWidget {
  Container2({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.isAntiAlias = true,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    super.child,
    this.clipBehavior = Clip.none,
  }) : assert(margin == null || margin.isNonNegative),
       assert(padding == null || padding.isNonNegative),
       assert(decoration == null || decoration.debugAssertIsValid()),
       assert(constraints == null || constraints.debugAssertIsValid()),
       assert(decoration != null || clipBehavior == Clip.none),
       assert(
         color == null || decoration == null,
         'Cannot provide both a color and a decoration\n'
         'To provide both, use "decoration: BoxDecoration(color: color)".',
       ),
       constraints = (width != null || height != null)
           ? constraints?.tighten(width: width, height: height) ??
                 BoxConstraints.tightFor(width: width, height: height)
           : constraints;

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool isAntiAlias;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    return switch ((padding, decoration?.padding)) {
      (null, final EdgeInsetsGeometry? padding) => padding,
      (final EdgeInsetsGeometry? padding, null) => padding,
      (_) => padding!.add(decoration!.padding),
    };
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderContainer(
      alignment: alignment,
      padding: _paddingIncludingDecoration,
      color: color,
      isAntiAlias: isAntiAlias,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      additionalConstraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderContainer renderObject) {
    renderObject.alignment = alignment;
    renderObject.padding = _paddingIncludingDecoration;
    renderObject.color = color;
    renderObject.isAntiAlias = isAntiAlias;
    renderObject.decoration = decoration;
    renderObject.foregroundDecoration = foregroundDecoration;
    renderObject.additionalConstraints = constraints;
    renderObject.margin = margin;
    renderObject.transform = transform;
    renderObject.transformAlignment = transformAlignment;
    renderObject.clipBehavior = clipBehavior;
    renderObject.textDirection = Directionality.maybeOf(context);
  }
}

class RenderContainer extends RenderComponentBox
    with RenderComponentBoxWithChildMixin<RenderBox> {
  RenderContainer({
    required AlignmentGeometry? alignment,
    required EdgeInsetsGeometry? padding,
    required Color? color,
    required bool isAntiAlias,
    required Decoration? decoration,
    required Decoration? foregroundDecoration,
    required BoxConstraints? additionalConstraints,
    required EdgeInsetsGeometry? margin,
    required Matrix4? transform,
    required AlignmentGeometry? transformAlignment,
    required Clip clipBehavior,
    required TextDirection? textDirection,
    RenderBox? child,
  }) : _alignment = alignment,
       _padding = padding,
       _color = color,
       _isAntiAlias = isAntiAlias,
       _decoration = decoration,
       _foregroundDecoration = foregroundDecoration,
       _additionalConstraints = additionalConstraints,
       _margin = margin,
       _transform = transform,
       _transformAlignment = transformAlignment,
       _clipBehavior = clipBehavior,
       _textDirection = textDirection {
    this.child = child;
  }

  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;
  set alignment(AlignmentGeometry? value) {
    if (_alignment == value) return;
    if (_alignment == null || value == null) {
      _alignment = value;
      markNeedsBuild();
    } else {
      _alignment = value;
      _alignmentRenderObject!.alignment = value;
    }
  }

  EdgeInsetsGeometry? get padding => _padding;
  EdgeInsetsGeometry? _padding;
  set padding(EdgeInsetsGeometry? value) {
    if (_padding == value) return;
    if (_padding == null || value == null) {
      _padding = value;
      markNeedsBuild();
    } else {
      _padding = value;
      _paddingRenderObject!.padding = value;
    }
  }

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color == value) return;
    if (_color == null || value == null) {
      _color = value;
      markNeedsBuild();
    } else {
      _color = value;
      _colorRenderObject!.color = value;
    }
  }

  bool get isAntiAlias => _isAntiAlias;
  bool _isAntiAlias;
  set isAntiAlias(bool value) {
    assert(_color != null);
    if (_isAntiAlias == value) return;
    _isAntiAlias = value;
    _colorRenderObject!.isAntiAlias = value;
  }

  Decoration? get decoration => _decoration;
  Decoration? _decoration;
  set decoration(Decoration? value) {
    if (_decoration == value) return;
    if (_decoration == null || value == null) {
      _decoration = value;
      markNeedsBuild();
    } else {
      _decoration = value;
      _decorationRenderObject!.decoration = value;
    }
  }

  Decoration? get foregroundDecoration => _foregroundDecoration;
  Decoration? _foregroundDecoration;
  set foregroundDecoration(Decoration? value) {
    if (_foregroundDecoration == value) return;
    if (_foregroundDecoration == null || value == null) {
      _foregroundDecoration = value;
      markNeedsBuild();
    } else {
      _foregroundDecoration = value;
      _foregroundDecorationRenderObject!.decoration = value;
    }
  }

  BoxConstraints? get additionalConstraints => _additionalConstraints;
  BoxConstraints? _additionalConstraints;
  set additionalConstraints(BoxConstraints? value) {
    if (_additionalConstraints == value) return;
    if (_additionalConstraints == null || value == null) {
      _additionalConstraints = value;
      markNeedsBuild();
    } else {
      _additionalConstraints = value;
      _additionalConstraintsRenderObject!.additionalConstraints = value;
    }
  }

  EdgeInsetsGeometry? get margin => _margin;
  EdgeInsetsGeometry? _margin;
  set margin(EdgeInsetsGeometry? value) {
    if (_margin == value) return;
    if (_margin == null || value == null) {
      _margin = value;
      markNeedsBuild();
    } else {
      _marginRenderObject!.padding = value;
      _margin = value;
    }
  }

  Matrix4? _transform;
  Matrix4? get transform => _transform;
  set transform(Matrix4? value) {
    if (_transform == value) return;
    if (_transform == null || value == null) {
      _transform = value;
      markNeedsBuild();
    } else {
      _transformRenderObject!.transform = value;
      _transform = value;
    }
  }

  AlignmentGeometry? _transformAlignment;
  AlignmentGeometry? get transformAlignment => _transformAlignment;
  set transformAlignment(AlignmentGeometry? value) {
    if (_transformAlignment == value) return;

    final transform = _transformRenderObject;
    if (transform != null) {
      transform.alignment = value;
    }

    _transformAlignment = value;
  }

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    assert(value == Clip.none || _decoration != null);
    if (_clipBehavior == value) return;
    if (_clipBehavior == Clip.none || value == Clip.none) {
      _clipBehavior = value;
      markNeedsBuild();
    } else {
      _clipBehavior = value;
      _clipRenderObject!.clipBehavior = value;
    }
  }

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;

    final alignment = _alignmentRenderObject;
    if (alignment != null) {
      alignment.textDirection = value;
    }

    final clip = _clipRenderObject;
    if (clip != null) {
      clip.clipper = _DecorationClipper(
        decoration: _decoration!,
        textDirection: value,
      );
    }

    _textDirection = value;
  }

  final Map<_RenderContainerSlot, RenderBox?> _renderObjects = {};

  RenderPositionedBox? get _alignmentRenderObject =>
      _renderObjects[_RenderContainerSlot.alignment] as RenderPositionedBox?;
  RenderPadding? get _paddingRenderObject =>
      _renderObjects[_RenderContainerSlot.padding] as RenderPadding?;
  _RenderColoredBox? get _colorRenderObject =>
      _renderObjects[_RenderContainerSlot.color] as _RenderColoredBox?;
  RenderDecoratedBox? get _decorationRenderObject =>
      _renderObjects[_RenderContainerSlot.decoration] as RenderDecoratedBox?;
  RenderDecoratedBox? get _foregroundDecorationRenderObject =>
      _renderObjects[_RenderContainerSlot.foregroundDecoration]
          as RenderDecoratedBox?;
  RenderConstrainedBox? get _additionalConstraintsRenderObject =>
      _renderObjects[_RenderContainerSlot.additionalConstraints]
          as RenderConstrainedBox?;
  RenderPadding? get _marginRenderObject =>
      _renderObjects[_RenderContainerSlot.margin] as RenderPadding?;
  RenderTransform? get _transformRenderObject =>
      _renderObjects[_RenderContainerSlot.transform] as RenderTransform?;
  RenderClipPath? get _clipRenderObject =>
      _renderObjects[_RenderContainerSlot.clipBehavior] as RenderClipPath?;

  @override
  RenderBox? build() {
    RenderBox? result = child;

    var canAlign = true;
    if (result == null &&
        (_additionalConstraints == null || !_additionalConstraints!.isTight)) {
      canAlign = false;
      result = RenderLimitedBox(
        maxWidth: 0,
        maxHeight: 0,
        child: RenderConstrainedBox(
          additionalConstraints: const BoxConstraints.expand(),
        ),
      );
    }

    result = _buildRenderObject(
      slot: .alignment,
      condition: canAlign && _alignment != null,
      create: () => RenderPositionedBox(
        alignment: _alignment!,
        textDirection: _textDirection,
        child: result,
      ),
      update: (renderObject) {
        renderObject.alignment = _alignment!;
        renderObject.textDirection = _textDirection;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .padding,
      condition: _padding != null,
      create: () => RenderPadding(padding: _padding!, child: result),
      update: (renderObject) {
        renderObject.padding = _padding!;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .color,
      condition: _color != null,
      create: () => _RenderColoredBox(
        color: _color!,
        isAntiAlias: _isAntiAlias,
        child: result,
      ),
      update: (renderObject) {
        renderObject.color = _color!;
        renderObject.isAntiAlias = _isAntiAlias;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .clipBehavior,
      condition: _clipBehavior != Clip.none,
      create: () => RenderClipPath(
        clipper: _DecorationClipper(
          textDirection: _textDirection,
          decoration: _decoration!,
        ),
        clipBehavior: _clipBehavior,
        child: result,
      ),
      update: (renderObject) {
        renderObject.clipper = _DecorationClipper(
          textDirection: _textDirection,
          decoration: _decoration!,
        );
        renderObject.clipBehavior = _clipBehavior;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .decoration,
      condition: _decoration != null,
      create: () => RenderDecoratedBox(decoration: _decoration!, child: result),
      update: (renderObject) {
        renderObject.decoration = _decoration!;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .foregroundDecoration,
      condition: _foregroundDecoration != null,
      create: () =>
          RenderDecoratedBox(decoration: _foregroundDecoration!, child: result),
      update: (renderObject) {
        renderObject.decoration = _foregroundDecoration!;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .additionalConstraints,
      condition: _additionalConstraints != null,
      create: () => RenderConstrainedBox(
        additionalConstraints: _additionalConstraints!,
        child: result,
      ),
      update: (renderObject) {
        renderObject.additionalConstraints = _additionalConstraints!;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .margin,
      condition: _margin != null,
      create: () => RenderPadding(padding: _margin!, child: result),
      update: (renderObject) {
        renderObject.padding = _margin!;
        renderObject.child = result;
      },
      child: result,
    );

    result = _buildRenderObject(
      slot: .transform,
      condition: _transform != null,
      create: () => RenderTransform(transform: _transform!, child: result),
      update: (renderObject) {
        renderObject.transform = _transform!;
        renderObject.child = result;
      },
      child: result,
    );

    return result;
  }

  RenderBox? _buildRenderObject<TRenderObject extends RenderBox>({
    required _RenderContainerSlot slot,
    required bool condition,
    required TRenderObject Function() create,
    required void Function(TRenderObject) update,
    required RenderBox? child,
  }) {
    var renderObject = _renderObjects[slot] as TRenderObject?;

    // Destroy the render object if the condition is not met.
    if (!condition) {
      if (renderObject != null) {
        final parent = renderObject.parent as RenderObjectWithChildMixin?;
        parent?.child = null;
        _renderObjects.remove(slot);
      }

      return child;
    }

    // Otherwise create or update the render object.
    if (renderObject == null) {
      renderObject = create();
      _renderObjects[slot] = renderObject;
    } else {
      update(renderObject);
    }

    // Update the child's parent and the render object's child.
    final childPreviousParent = child?.parent as RenderObjectWithChildMixin?;
    if (childPreviousParent != null && childPreviousParent != renderObject) {
      childPreviousParent.child = null;
    }
    (renderObject as RenderObjectWithChildMixin).child = child;

    return renderObject;
  }
}

enum _RenderContainerSlot {
  alignment,
  padding,
  color,
  clipBehavior,
  decoration,
  foregroundDecoration,
  additionalConstraints,
  margin,
  transform,
}

// Copied from:
// https://github.com/flutter/flutter/blob/ec6f55023760ea4f44d311b9c69c39910f6b8b0c/packages/flutter/lib/src/widgets/basic.dart#L8461
class _RenderColoredBox extends RenderProxyBoxWithHitTestBehavior {
  _RenderColoredBox({
    required Color color,
    required bool isAntiAlias,
    super.child,
  }) : _color = color,
       _isAntiAlias = isAntiAlias,
       super(behavior: HitTestBehavior.opaque);

  /// The fill color for this render object.
  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  bool get isAntiAlias => _isAntiAlias;
  bool _isAntiAlias;
  set isAntiAlias(bool value) {
    if (value == _isAntiAlias) {
      return;
    }
    _isAntiAlias = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // It's tempting to want to optimize out this `drawRect()` call if the
    // color is transparent (alpha==0), but doing so would be incorrect. See
    // https://github.com/flutter/flutter/pull/72526#issuecomment-749185938 for
    // a good description of why.
    if (size > Size.zero) {
      context.canvas.drawRect(
        offset & size,
        Paint()
          ..isAntiAlias = isAntiAlias
          ..color = color,
      );
    }
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

// Copied from:
// https://github.com/flutter/flutter/blob/ec6f55023760ea4f44d311b9c69c39910f6b8b0c/packages/flutter/lib/src/widgets/container.dart#L477
class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection? textDirection, required this.decoration})
    : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) {
    return decoration.getClipPath(Offset.zero & size, textDirection);
  }

  @override
  bool shouldReclip(_DecorationClipper oldClipper) {
    return oldClipper.decoration != decoration ||
        oldClipper.textDirection != textDirection;
  }
}
