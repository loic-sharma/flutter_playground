import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract class RenderComponentBoxWithChildWidget extends RenderObjectWidget {
  const RenderComponentBoxWithChildWidget({super.key, this.child});

  final Widget? child;

  @override
  RenderComponentBoxWithChildElement createElement() =>
      RenderComponentBoxWithChildElement(this);
}

class RenderComponentBoxWithChildElement extends RenderObjectElement {
  RenderComponentBoxWithChildElement(
    RenderComponentBoxWithChildWidget super.widget,
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
      (widget as RenderComponentBoxWithChildWidget).child,
      null,
    );

    final renderObject = this.renderObject as RenderComponentBoxWithChildMixin;
    renderObject.rebuildIfNecessary();
  }

  @override
  void update(RenderComponentBoxWithChildWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(
      _child,
      (widget as RenderComponentBoxWithChildWidget).child,
      null,
    );

    final renderObject = this.renderObject as RenderComponentBoxWithChildMixin;
    renderObject.rebuildIfNecessary();
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final renderObject = this.renderObject as RenderComponentBoxWithChildMixin;
    assert(slot == null);
    // TODO: Should this accept any RenderObject child?
    renderObject.child = child as RenderBox;
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
    final renderObject = this.renderObject as RenderComponentBoxWithChildMixin;
    assert(slot == null);
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

abstract class RenderComponentBox extends RenderBox
    with RenderObjectWithLayoutCallbackMixin {
  RenderBox? _computedChild;

  bool _needsBuild = true;

  void markNeedsBuild() {
    if (_needsBuild) return;
    _needsBuild = true;
    markNeedsLayout();
  }

  @protected
  RenderBox? build();

  void rebuildIfNecessary() {
    if (!_needsBuild) return;
    var newComputedChild = build();
    if (newComputedChild != _computedChild) {
      if (_computedChild != null) {
        dropChild(_computedChild!);
      }
      if (newComputedChild != null) {
        adoptChild(newComputedChild);
      }
      _computedChild = newComputedChild;
    }
    _needsBuild = false;
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
    return _computedChild != null
        ? <DiagnosticsNode>[_computedChild!.toDiagnosticsNode(name: 'child')]
        : <DiagnosticsNode>[];
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
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final double? result = _computedChild?.getDryBaseline(
      constraints,
      baseline,
    );
    return result ?? super.computeDryBaseline(constraints, baseline);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computedChild?.getDryLayout(constraints) ??
        computeSizeForNoChild(constraints);
  }

  @override
  void layoutCallback() {
    rebuildIfNecessary();
  }

  @override
  void performLayout() {
    runLayoutCallback();

    size =
        (_computedChild?..layout(constraints, parentUsesSize: true))?.size ??
        computeSizeForNoChild(constraints);
    return;
  }

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

mixin RenderComponentBoxWithChildMixin<ChildType extends RenderBox>
    on RenderComponentBox {
  ChildType? get child => _child;
  ChildType? _child;
  set child(ChildType? newChild) {
    if (_child != newChild) {
      final oldChild = _child;
      _child = newChild;
      didUpdateChild(oldChild);
      markNeedsBuild();
    }
  }

  @mustCallSuper
  @protected
  void didUpdateChild(ChildType? oldChild) {}
}
