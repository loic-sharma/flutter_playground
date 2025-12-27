# Container state loss

## Background

The `Container` widget changes the widget tree hierarchy when its arguments
change. This causes its child to lose its state if it doesn't have a global key.

Example app that shows this issue:
https://dartpad.dev/?id=bd243d23a7fd661563519c3eebece032

Issue: https://github.com/flutter/flutter/issues/161698

## Solution

This prototypes a `Container2` widget, which is a drop-in replacement for
`Container`. Instead of composing widgets, `Container2` creates a single render
object, `RenderContainer`. This ensures a stable widget tree depth and avoids
the state loss problem.

## Composing render objects

`RenderContainer` composes zero or more render objects based on `Container2`'s
arguments. `RenderContainer` needs a build phase, similar to the widget tree's
build phase.

This prototype introduces `RenderComponentBox`, a base class for render objects
that have a build phase to compose children render objects:

```dart
class MyButton extends RenderComponentBox
    with RenderComponentBoxWithChildMixin<RenderBox> {
  MyButton({required this.onPressed, RenderBox? child}) {
    this.child = child;
  }

  final VoidCallback onPressed;

  RenderBox? _root;
  RenderObjectWithChildMixin? _childParent;

  @override
  void didUpdateChild(RenderBox? oldChild) {
    _childParent?.child = child;
  }

  @override
  RenderBox? build() {
    return _root ??= RenderPointerListener(
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
