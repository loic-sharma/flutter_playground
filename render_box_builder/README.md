# :warning: ARCHIVED

`RenderBoxBuilder` attempted to make it easier to compose
render objects dynamically. However, it turns out that that's
already possible using `RenderProxyBox`:

```dart
class RenderHello extends RenderProxyBox {
  RenderHello() {
    child = RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}
```

One pickle is if your custom render object needs to accept a
child:

1. Naming the child `child` conflicts with `RenderProxyBox.child`
2. You cannot use `SingleChildRenderObjectWidget`.

One workaround is to name this child `delegatedChild`:

```dart
class RenderDemo extends RenderProxyBox {
  RenderDemo({
    required RenderBox delegatedChild,
  }) {
    child = RenderPadding(
      padding: .all(8),
      child: delegatedChild,
    );
  }

  RenderBox? get delegatedChild => child!.child;
  set delegatedChild(RenderBox? value) {
    child!.child = value;
  }
}
```

And then create a custom `RenderObjectWidget` and `RenderObjectElement`:

```dart
class Demo extends RenderObjectWidget {
  const Demo({this.child});

  final Widget? child;

  @override
  RenderObjectElement createElement() => _DemoElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDemo();
  }

  @override
  void updateRenderObject(BuildContext context, RenderDemo renderObject) {
  }
}

class _DemoElement extends RenderObjectElement {
  _DemoElement(Demo super.widget);

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
      (widget as Demo).child,
      null,
    );
  }

  @override
  void update(Demo newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(
      _child,
      (widget as Demo).child,
      null,
    );
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final renderDemo = renderObject as RenderDemo;
    assert(slot == null);
    renderDemo.delegatedChild = child as RenderBox;
    assert(renderDemo == renderObject);
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
    final renderDemo = renderObject as RenderDemo;
    assert(slot == null);
    assert(renderDemo.delegatedChild == child);
    renderDemo.delegatedChild = null;
    assert(renderDemo == renderObject);
  }
}
```

# Original README

<details>
<summary>Original README...</summary>

# `RenderBoxBuilder`

`RenderBoxBuilder` is a base class for render objects
that have a build phase to compose render objects dynamically:

```dart
class RenderHello extends RenderBoxBuilder {
  RenderBox? _root;

  @override
  RenderBox build() {
    return _root ??= RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}
```

The `RenderBoxBuilder` can use the `RenderBoxBuilderWithChildMixin` mixin
to accept a child and wrap it with zero or more render objects:

```dart
class MyButton extends RenderBoxBuilder
    with RenderBoxBuilderWithChildMixin<RenderBox> {
  MyButton({required this.onPressed, RenderBox? child}) {
    this.child = child;
  }

  final VoidCallback onPressed;
  RenderBox? _button;
  RenderObjectWithChildMixin? _childParent;

  @override
  void didUpdateChild(RenderBox? oldChild) {
    _childParent?.child = child;
  }

  @override
  RenderBox build() {
    return _button ??= RenderPointerListener(
      onPointerDown: (event) => onPressed(),
      child: RenderDecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0000FF),
          borderRadius: .circular(4.0),
        ),
        child: _childParent = RenderPadding(
          padding: const .all(16.0),
          child: child,
        ),
      ),
    );
  }
}
```

</details>
