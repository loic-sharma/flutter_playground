# Flutter custom analyzers

This prototypes custom lints to enforce Flutter's updated
style guide.

## `always_specify_property_types`

Specify type annotations for top-level variables, static fields, and instance fields.

https://github.com/dart-lang/sdk/issues/61899

## Details

**DO** annotate types for top-level variables, static fields, and instance fields.

## Bad examples

```dart
const magicNumber = 4;

class Foo {
  final magicNumber1 = 4;
  final _magicNumber2 = 4;
  static final magicNumber2 = 4;
  static const magicNumber3 = 4;
}
```

## Good examples

```dart
const int magicNumber = 4;

class Foo {
  final int magicNumber1 = 4;
  final int _magicNumber2 = 4;
  static int final magicNumber2 = 4;
  static int const magicNumber3 = 4;
}
```

## `specify_types_on_closure_parameters`

Annotate types for function expression parameters.

https://github.com/dart-lang/sdk/issues/61867

## Details

**DO** annotate types for function expression parameters.

## Bad examples

```dart
TweenAnimationBuilder(
  // ...
  // ⚠️ This closure is missing type annotations.
  builder: (context, value, child) {
    // ...
  },
),
```

## Good examples

```dart
TweenAnimationBuilder(
  // ...
  builder: (BuildContext context, double value, Widget? child) {
    // ...
  },
),
```
