# `RenderWrappedBox`

> [!IMPORTANT]  
> This prototype requires applying the patch in
> [`flutter.patch`](./flutter.patch) to your Flutter SDK.

`RenderWrappedBox` makes it easier to compose render objects.

Hello world example:

```dart
class RenderHello extends RenderWrappedBox {
  RenderHello() {
    wrappedChild = RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}
```

If you apply the patch in [`flutter.patch`](./flutter.patch)
to the Flutter SDK, you can also create a render object that
accepts a child render object and wraps it in additional
render objects:

```dart
class RenderPaddingWrapper extends RenderWrappedBox
    with RenderWrappedBoxWithChildMixin<RenderBox> {
  RenderPaddingWrapper({RenderBox? child}) {
    wrappedChild = RenderPadding(
      padding: .all(8),
      child: child,
    );
  }

  @override
  RenderPadding get wrappedChild => super.wrappedChild as RenderPadding;

  @override
  RenderBox? get child => wrappedChild.child;

  @override
  set child(RenderBox? value) => wrappedChild.child = value;
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

class PaddingWrapper extends SingleChildRenderObject {
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
// A render object that returns "Hello world".
class RenderHello extends RenderProxyBox {
  RenderHello() {
    child = RenderParagraph(
      TextSpan(text: 'Hello world'),
      textDirection: .ltr,
    );
  }
}

// A render object that accepts a render object
// and wraps it with some padding.
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
   which could break your render object's logic. For example,
   updating `RenderPaddingWrapper.child` would break this render object.

2. `RenderPaddingWrapper` accepts a `delegatedChild` render object
   and wraps it with a `RenderPadding`. You have to create a
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
