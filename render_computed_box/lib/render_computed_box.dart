import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract class RenderComputedBoxWithChildWidget extends RenderObjectWidget {
  const RenderComputedBoxWithChildWidget({super.key, this.child});

  final Widget? child;

  @override
  RenderComputedBoxWithChildElement createElement() =>
      RenderComputedBoxWithChildElement(this);
}

class RenderComputedBoxWithChildElement extends RenderObjectElement {
  RenderComputedBoxWithChildElement(
    RenderComputedBoxWithChildWidget super.widget,
  );

  Element? _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _child = updateChild(
      _child,
      (widget as RenderComputedBoxWithChildWidget).child,
      null,
    );
  }

  @override
  void update(RenderComputedBoxWithChildWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(
      _child,
      (widget as RenderComputedBoxWithChildWidget).child,
      null,
    );
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final renderObject =
        this.renderObject as RenderComputedBoxWithDelegatedChildMixin<RenderBox>;
    assert(slot == null);
    renderObject.delegatedChild = child as RenderBox;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(
    RenderObject child,
    Object? oldSlot,
    Object? newSlot,
  ) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final renderObject =
        this.renderObject as RenderComputedBoxWithDelegatedChildMixin<RenderBox>;
    assert(slot == null);
    assert(renderObject.delegatedChild == child);
    renderObject.delegatedChild = null;
    assert(renderObject == this.renderObject);
  }
}

class RenderComputedBox extends RenderBox {
  RenderComputedBox([RenderBox? computedChild]) {
    this.computedChild = computedChild;
  }

  RenderBox? _computedChild;

  RenderBox? get computedChild => _computedChild;

  @protected
  set computedChild(RenderBox? value) {
    if (_computedChild != null) {
      dropChild(_computedChild!);
    }
    _computedChild = value;
    if (_computedChild != null) {
      adoptChild(_computedChild!);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _computedChild?.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    _computedChild?.detach();
  }

  @override
  void redepthChildren() {
    if (_computedChild != null) {
      redepthChild(_computedChild!);
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_computedChild != null) {
      visitor(_computedChild!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return computedChild != null
        ? <DiagnosticsNode>[computedChild!.toDiagnosticsNode(name: 'computedChild')]
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
    return _computedChild?.getMinIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computedChild?.getMaxIntrinsicWidth(height) ?? 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computedChild?.getMinIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computedChild?.getMaxIntrinsicHeight(width) ?? 0.0;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return _computedChild?.getDistanceToActualBaseline(baseline) ??
        super.computeDistanceToActualBaseline(baseline);
  }

  @override
  @protected
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final double? result = _computedChild?.getDryBaseline(constraints, baseline);
    return result ?? super.computeDryBaseline(constraints, baseline);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computedChild?.getDryLayout(constraints) ?? computeSizeForNoChild(constraints);
  }

  @override
  void performLayout() {
    size =
        (_computedChild?..layout(constraints, parentUsesSize: true))?.size ??
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
    return _computedChild?.hitTest(result, position: position) ?? false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = _computedChild;
    if (child == null) {
      return;
    }
    context.paintChild(child, offset);
  }
}

mixin RenderComputedBoxWithDelegatedChildMixin<ChildType extends RenderBox>
    on RenderComputedBox {
  ChildType? get delegatedChild;
  set delegatedChild(ChildType? value);
}
