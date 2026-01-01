import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderComposedBox extends RenderBox
    with RenderComposedBoxMixin<RenderBox> {
  RenderComposedBox([RenderBox? composedChild]) {
    this.composedChild = composedChild;
  }
}

mixin RenderComposedBoxMixin<ChildType extends RenderBox> on RenderBox {
  ChildType? _composedChild;

  ChildType? get composedChild => _composedChild;

  @protected
  set composedChild(ChildType? value) {
    if (_composedChild != null) {
      dropChild(_composedChild!);
    }
    _composedChild = value;
    if (_composedChild != null) {
      adoptChild(_composedChild!);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _composedChild?.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    _composedChild?.detach();
  }

  @override
  void redepthChildren() {
    if (_composedChild != null) {
      redepthChild(_composedChild!);
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_composedChild != null) {
      visitor(_composedChild!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return composedChild != null
        ? <DiagnosticsNode>[composedChild!.toDiagnosticsNode(name: 'composedChild')]
        : <DiagnosticsNode>[];
  }

  @override
  void setupParentData(RenderObject child) {
    // We don't actually use the offset argument in BoxParentData, so let's
    // avoid allocating it at all.
    if (child.parentData is! ParentData) {
      child.parentData = ParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _composedChild?.getMinIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _composedChild?.getMaxIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _composedChild?.getMinIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _composedChild?.getMaxIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return _composedChild?.getDistanceToActualBaseline(baseline) ??
        super.computeDistanceToActualBaseline(baseline);
  }

  @override
  @protected
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final double? result = _composedChild?.getDryBaseline(constraints, baseline);
    return result ?? super.computeDryBaseline(constraints, baseline);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _composedChild?.getDryLayout(constraints) ?? computeSizeForNoChild(constraints);
  }

  @override
  void performLayout() {
    size =
        (_composedChild?..layout(constraints, parentUsesSize: true))?.size ??
        computeSizeForNoChild(constraints);
    return;
  }

  /// Calculate the size the [RenderProxyBox] would have under the given
  /// [BoxConstraints] for the case where it does not have a child.
  Size computeSizeForNoChild(BoxConstraints constraints) {
    return constraints.smallest;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return _composedChild?.hitTest(result, position: position) ?? false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = _composedChild;
    if (child == null) {
      return;
    }
    context.paintChild(child, offset);
  }
}

mixin RenderComposedBoxWithChildMixin<ChildType extends RenderBox>
    on RenderComposedBoxMixin<ChildType>
    implements RenderObjectWithChild<ChildType> {
  @override
  bool debugValidateChild(RenderObject child) {
    return debugValidateRenderObjectWithChild<RenderBox>(this, child);
  }
}