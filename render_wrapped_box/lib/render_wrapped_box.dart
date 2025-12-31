import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderWrappedBox extends RenderBox
    with RenderWrappedBoxMixin<RenderBox> {
  RenderWrappedBox([RenderBox? wrappedChild]) {
    this.wrappedChild = wrappedChild;
  }
}

mixin RenderWrappedBoxMixin<ChildType extends RenderBox> on RenderBox {
  ChildType? _wrappedChild;

  ChildType? get wrappedChild => _wrappedChild;

  @protected
  set wrappedChild(ChildType? value) {
    if (_wrappedChild != null) {
      dropChild(_wrappedChild!);
    }
    _wrappedChild = value;
    if (_wrappedChild != null) {
      adoptChild(_wrappedChild!);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _wrappedChild?.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    _wrappedChild?.detach();
  }

  @override
  void redepthChildren() {
    if (_wrappedChild != null) {
      redepthChild(_wrappedChild!);
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_wrappedChild != null) {
      visitor(_wrappedChild!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return wrappedChild != null
        ? <DiagnosticsNode>[wrappedChild!.toDiagnosticsNode(name: 'wrappedChild')]
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
    return _wrappedChild?.getMinIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _wrappedChild?.getMaxIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _wrappedChild?.getMinIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _wrappedChild?.getMaxIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return _wrappedChild?.getDistanceToActualBaseline(baseline) ??
        super.computeDistanceToActualBaseline(baseline);
  }

  @override
  @protected
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final double? result = _wrappedChild?.getDryBaseline(constraints, baseline);
    return result ?? super.computeDryBaseline(constraints, baseline);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _wrappedChild?.getDryLayout(constraints) ?? computeSizeForNoChild(constraints);
  }

  @override
  void performLayout() {
    size =
        (_wrappedChild?..layout(constraints, parentUsesSize: true))?.size ??
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
    return _wrappedChild?.hitTest(result, position: position) ?? false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = _wrappedChild;
    if (child == null) {
      return;
    }
    context.paintChild(child, offset);
  }
}

mixin RenderWrappedBoxWithChildMixin<ChildType extends RenderBox>
    on RenderWrappedBoxMixin<ChildType>
    implements RenderObjectWithChild<ChildType> {
  @override
  bool debugValidateChild(RenderObject child) {
    return debugValidateRenderObjectWithChild<RenderBox>(this, child);
  }
}