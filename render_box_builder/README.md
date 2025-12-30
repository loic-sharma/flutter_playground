# :warning: ARCHIVED

This was superseded by [`RenderComputedBox`](../render_computed_box/).

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
