import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract class OptionallyWrappedChildWidget extends RenderObjectWidget {
  const OptionallyWrappedChildWidget({super.key, this.enabled = true, this.child});

  final bool enabled;
  final Widget? child;

  @override
  RenderObjectElement createElement() => _OptionallyWrappedChildWidgetElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _OptionallyWrappedRenderBox(
      enabled: enabled,
      wrapperChild: createWrapperRenderBox(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final box = renderObject as _OptionallyWrappedRenderBox;
    box.enabled = enabled;
    updateWrapperRenderBox(context, box.wrapperChild);
  }

  @protected
  RenderBox createWrapperRenderBox(BuildContext context);

  @protected
  void updateWrapperRenderBox(BuildContext context, covariant RenderBox renderBox) {}
}

class _OptionallyWrappedChildWidgetElement extends RenderObjectElement {
  _OptionallyWrappedChildWidgetElement(OptionallyWrappedChildWidget super.widget);

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
      (widget as OptionallyWrappedChildWidget).child,
      null,
    );
  }

  @override
  void update(OptionallyWrappedChildWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(
      _child,
      (widget as OptionallyWrappedChildWidget).child,
      null,
    );
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final optinallyWrappedBox = renderObject as _OptionallyWrappedRenderBox;
    assert(slot == null);
    optinallyWrappedBox.wrappedChild = child as RenderBox;
    assert(optinallyWrappedBox == renderObject);
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
    final optinallyWrappedBox = renderObject as _OptionallyWrappedRenderBox;
    assert(slot == null);
    assert(optinallyWrappedBox.wrappedChild == child);
    optinallyWrappedBox.wrappedChild = null;
    assert(optinallyWrappedBox == renderObject);
  }
}

// TODO: _OptionallyWrappedRenderBox.child has a public setter.
// Using this setter breaks _OptionallyWrappedRenderBox.
// We should make _OptionallyWrappedRenderBox.child read-only.
class _OptionallyWrappedRenderBox extends RenderProxyBox {
  _OptionallyWrappedRenderBox({
    bool enabled = true,
    required RenderBox wrapperChild,
    RenderBox? wrappedChild,
  }) : _enabled = enabled,
       _wrapperChild = wrapperChild,
       _wrappedChild = wrappedChild {
    if (enabled) {
      child = wrapperChild;
      (wrapperChild as RenderObjectWithChildMixin).child = wrappedChild;
    } else {
      child = wrappedChild;
    }
  }

  bool get enabled => _enabled;
  bool _enabled;
  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      if (_enabled) {
        child = wrapperChild;
        (wrapperChild as RenderObjectWithChildMixin).child = wrappedChild;
      } else {
        (wrapperChild as RenderObjectWithChildMixin).child = null;
        child = wrappedChild;
      }
    }
  }

  RenderBox get wrapperChild => _wrapperChild;
  RenderBox _wrapperChild;
  set wrapperChild(RenderBox value) {
    if (_wrapperChild != value) {
      if (enabled) {
        (_wrapperChild as RenderObjectWithChildMixin).child = null;
        (value as RenderObjectWithChildMixin).child = wrappedChild;
        child = value;
      }
      _wrapperChild = value;
    }
  }

  RenderBox? get wrappedChild => _wrappedChild;
  RenderBox? _wrappedChild;
  set wrappedChild(RenderBox? value) {
    if (_wrappedChild != value) {
      if (enabled) {
        (wrapperChild as RenderObjectWithChildMixin).child = value;
      } else {
        child = value;
      }
      _wrappedChild = value;
    }
  }
}
