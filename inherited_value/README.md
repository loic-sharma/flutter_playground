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
  runApp(MaterialApp(home: CounterScreen()));
}

class CounterModel extends InheritedWidget {
  const CounterModel({
    required this.increment,
    required super.child,
  });

  final VoidCallback increment;

  static CounterModel? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterModel>();
  }

  static CounterModel of(BuildContext context) {
    final CounterModel? model = maybeOf(context);
    assert(model != null);
    return model!;
  }

  @override
  bool updateShouldNotify(CounterModel oldWidget) {
    return oldWidget.increment != increment;
  }
}

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return CounterModel(
      increment: () => setState(() => counter++),
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
    return FloatingActionButton(
      onPressed: CounterModel.of(context).increment,
      child: const Icon(Icons.add),
    );
  }
}
```


</td>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CounterScreen()));
}

class CounterModel({final VoidCallback increment});

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return InheritedValue(
      create: () => CounterModel(
        increment: () => setState(() => counter++),
      ),
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
    return FloatingActionButton(
      onPressed: InheritedValue<CounterModel>.of(context).increment,
      child: const Icon(Icons.add),
    );
  }
}
```

</td>
</tr>
</table>

# InheritedValue.value

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
  runApp(MaterialApp(home: CounterScreen()));
}

class CounterModel extends InheritedWidget {
  const CounterModel({
    required this.counter,
    required super.child,
  });

  final int counter;

  static CounterModel? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterModel>();
  }

  static CounterModel of(BuildContext context) {
    final CounterModel? model = maybeOf(context);
    assert(model != null);
    return model!;
  }

  @override
  bool updateShouldNotify(CounterModel oldWidget) {
    return oldWidget.counter != counter;
  }
}

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CounterModel(
        counter: counter,
        child: DisplayCounter(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DisplayCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterModel model = CounterModel.of(context);
    return Center(child: Text('Count: ${model.counter}'));
  }
}
```


</td>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CounterScreen()));
}

class CounterModel({final int counter});

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InheritedValue.value(
        value: CounterModel(counter: counter),
        updateShouldNotify: (oldValue, newValue) {
          return oldValue.counter != newValue.counter;
        },
        child: DisplayCounter(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DisplayCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterModel model = InheritedValue<CounterModel>.of(context);
    return Center(child: Text('Count: ${model.counter}'));
  }
}
```

</td>
</tr>
</table>
  
# InheritedValue.multiple

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CounterScreen()));
}

class ColorModel({final Color buttonColor});
class CounterModel({final VoidCallback increment});

class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return InheritedValue.multiple(
      create: () => [
        ColorModel(buttonColor: Colors.blue),
        CounterModel(increment: () => setState(() => counter++)),
      ],
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
    final buttonColor = InheritedValue<ColorModel>.of(context).buttonColor;
    final onPressed = InheritedValue<CounterModel>.of(context).increment;
 
    return FloatingActionButton(
      backgroundColor: buttonColor,
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
```
