# `RenderComputedBox`

`RenderComputedBox` makes it easier to compose render objects.

Hello world example:

```dart
class RenderHello extends RenderComputedBox {
  RenderHello() {
    computedChild = RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}
```

You can also create a render object that accepts a child
render object and wraps it with additional render objects:

```dart
class RenderPaddingWrapper extends RenderComputedBox
    with RenderComputedBoxWithChildMixin<RenderBox> {
  RenderPaddingWrapper({
    RenderBox? delegatedChild,
  }) {
    computedChild = _delegatedChildParent = RenderPadding(
      padding: .all(8),
      child: delegatedChild,
    );
  }

  late final RenderPadding _delegatedChildParent;

  @override
  RenderBox? get delegatedChild => _delegatedChildParent.child;

  @override
  set delegatedChild(RenderBox? value) {
    _delegatedChildParent.child = value;
  }
}
```

These can be turned into widgets:

```dart
class Hello extends LeafRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHello();
  }
}

class PaddingWrapper extends RenderComputedBoxWithChildWidget {
  PaddingWrapper({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPaddingWrapper();
  }
}
```

## Why is this necessary?

It's already possible today to compose render objects using
`RenderProxyBox`:

```dart
class RenderHello extends RenderProxyBox {
  RenderHello() {
    child = RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}

class RenderPaddingWrapper extends RenderProxyBox {
  RenderPaddingWrapper({
    RenderBox? delegatedChild,
  }) {
    child = _delegatedChildParent = RenderPadding(
      padding: .all(8),
      child: delegatedChild,
    );
  }

  late final RenderPadding _delegatedChildParent;

  RenderBox? get delegatedChild => _delegatedChildParent.child;
  set delegatedChild(RenderBox? value) {
    _delegatedChildParent.child = value;
  }
}
```

However, this approach has problems:

1. `RenderProxyBox.child` is public. Anyone can update this property,
   which could break your render object's logic.

2. `RenderPaddingWrapper` accepts a `delegatedChild` render object
   and wraps it additional render objects. You have to create a
   custom element to use this render object in the widget tree.
   Using the normal `SingleChildRenderObjectWidget` would set
   `child` instead of `delegatedChild`.  This requires large
   amounts of boilerplate:

<details>
<summary>Custom element that sets delegatedChild...</summary>

```dart
class PaddingWrapper extends RenderObjectWidget {
  const PaddingWrapper({this.child});

  final Widget? child;

  @override
  RenderObjectElement createElement() => _PaddingWrapperElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPadding();
  }
}

class _PaddingWrapperElement extends RenderObjectElement {
  _PaddingWrapperElement(PaddingWrapper super.widget);

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
      (widget as PaddingWrapper).child,
      null,
    );
  }

  @override
  void update(PaddingWrapper newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(
      _child,
      (widget as PaddingWrapper).child,
      null,
    );
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final renderPaddingWrapper = renderObject as RenderPaddingWrapper;
    assert(slot == null);
    renderPaddingWrapper.delegatedChild = child as RenderBox;
    assert(renderPaddingWrapper == renderObject);
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
    final renderPaddingWrapper = renderObject as RenderPaddingWrapper;
    assert(slot == null);
    assert(renderPaddingWrapper.delegatedChild == child);
    renderPaddingWrapper.delegatedChild = null;
    assert(renderPaddingWrapper == renderObject);
  }
}
```

</details>

That's a lot of boilerplate!
