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

`RenderContainer` composes zero or more render objects based on `Container2`'s
arguments. It does so by exteniding [`RenderBoxBuilder`](../render_box_builder/).
