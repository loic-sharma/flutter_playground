# InheritedValue

<table>
<tr>
  <td>Before</td>
  <td>After</td>
</tr>
<tr>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

class AppColors extends InheritedWidget {
  const AppColors({
    required this.buttonColor,
    required super.child,
  });

  final Color buttonColor;

  static AppColors? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppColors>();
  }

  static AppColors of(BuildContext context) {
    final AppColors? model = maybeOf(context);
    assert(model != null);
    return model!;
  }

  @override
  bool updateShouldNotify(AppColors oldWidget) {
    return oldWidget.buttonColor != buttonColor;
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppColors(
      buttonColor: Colors.blue,
      child: Scaffold(
        body: Center(child: MyButton()),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.of(context).buttonColor,
      ),
      onPressed: () {},
      child: const Text('Hello world'),
    );
  }
}
```


</td>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

class AppColors({required final Color buttonColor});

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InheritedValue(
      create: () => AppColors(buttonColor: Colors.blue),
      child: Scaffold(
        body: Center(child: MyButton()),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppColors colors = InheritedValue.of<AppColors>(context);

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: colors.buttonColor),
      onPressed: () {},
      child: const Text('Hello world'),
    );
  }
}
```

</td>
</tr>
</table>

# InheritedValues

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CounterScreen()));
}

class AppColors({final Color buttonColor});
class CounterModel({final VoidCallback increment});

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return InheritedValues(
      create: (values) {
        values.add(AppColors(buttonColor: Colors.blue));
        values.add(CounterModel(increment: () => setState(() => counter++)));
      },
      child: Scaffold(
        body: Center(child: Text('Count: $counter')),
        floatingActionButton: IncrementButton(),
      ),
    );
  }
}

class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = InheritedValue.of<AppColors>(context);
 
    return FloatingActionButton(
      foregroundColor: colors.buttonColor,
      onPressed: () {
        // This uses "peek" to avoid creating a dependency.
        // IncrementButton does not need to rebuild when
        // the counter changes.
        InheritedValue.peek<CounterModel>(context).increment();
      },
      child: const Icon(Icons.add),
    );
  }
}
```

# RawInheritedValue

<table>
<tr>
  <td>Before</td>
  <td>After</td>
</tr>
<tr>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

class AppColors extends InheritedWidget {
  const AppColors({
    required this.buttonColor,
    required super.child,
  });

  final Color buttonColor;

  static AppColors? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppColors>();
  }

  static AppColors of(BuildContext context) {
    final AppColors? model = maybeOf(context);
    assert(model != null);
    return model!;
  }

  @override
  bool updateShouldNotify(AppColors oldWidget) {
    return oldWidget.buttonColor != buttonColor;
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppColors(
      buttonColor: Colors.blue,
      child: Scaffold(
        body: Center(child: MyButton()),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.of(context).buttonColor,
      ),
      onPressed: () {},
      child: const Text('Hello world'),
    );
  }
}
```


</td>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

class AppColors({required final Color buttonColor});

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawInheritedValue(
      value: AppColors(buttonColor: Colors.blue),
      updateShouldNotify: (oldValue, newValue) {
        return oldValue.buttonColor != newValue.buttonColor;
      },
      child: Scaffold(
        body: Center(child: MyButton()),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppColors colors = RawInheritedValue.of<AppColors>(context);

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: colors.buttonColor),
      onPressed: () {},
      child: const Text('Hello world'),
    );
  }
}
```

</td>
</tr>
</table>
