# Container state loss

## Background

`Container` composes widgets together depending on its arguments.
Changing `Container`'s arguments can change the widget tree hiarchy,
which can cause state loss if the child doesn't have a global key.
See: https://github.com/flutter/flutter/issues/161698.

Example app that shows the `Container` state loss issue:
https://dartpad.dev/?id=bd243d23a7fd661563519c3eebece032

## Solution

This prototypes a `Container2` widget, which is a drop-in replacement for
`Container`. Instead of composing widgets, `Container2` creates a single render
object, `RenderContainer`. This ensures a stable widget tree depth and avoids
the state loss problem.

`RenderContainer` composes zero or more render objects based on `Container2`'s
arguments. It does so by extending [`RenderBoxBuilder`](../render_box_builder/).
