# ComputedListenable

> [!WARNING]  
> ComputedListenable does not work well with Dart's hot reload.
> You need to hot restart after changing the callback's code.

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

final model = Model();

class Model extends ChangeNotifier {
  int get counter => _counter;
  var _counter = 0;

  bool get increase => _increase;
  var _increase = true;
  set increase(bool value) {
    if (_increase != value) {
      _increase = value;
      notifyListeners();
    }
  }

  void updateCount() {
    _counter += increase ? 1 : -1;
    notifyListeners();
  }
}

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final ValueNotifier<int> counter;
  late final ValueNotifier<bool> increase;

  @override
  void initState() {
    super.initState();
    counter = ValueNotifier(model.counter);
    increase = ValueNotifier(model.increase);
    model.addListener(_handleModelChanged);
  }

  void _handleModelChanged() {
    counter.value = model.counter;
    increase.value = model.increase;
  }

  @override
  void dispose() {
    model.removeListener(_handleModelChanged);
    counter.dispose();
    increase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: counter,
              builder: (context, counter, _) {
                return Text('Counter: $counter');
              },
            ),
            const SizedBox(height: 64),
            ValueListenableBuilder<bool>(
              valueListenable: increase,
              builder: (context, increase, _) {
                var direction = increase ? 'Increasing' : 'Decreasing';
                return Text('Direction: $direction');
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: increase,
              builder: (context, increaseValue, _) {
                return Switch(
                  value: increaseValue,
                  onChanged: (value) => model.increase = value,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.updateCount(),
        child: ValueListenableBuilder(
          valueListenable: increase,
          builder: (context, increase, _) {
            return Icon(
              increase ? Icons.arrow_upward : Icons.arrow_downward,
            );
          },
        ),
      ),
    );
  }
}
```


</td>
<td>

```dart
import 'package:flutter/material.dart';
import 'package:computed_listenable/computed_listenable.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

final model = Model();

class Model extends ChangeNotifier {
  int get counter => _counter;
  var _counter = 0;

  bool get increase => _increase;
  var _increase = true;
  set increase(bool value) {
    if (_increase != value) {
      _increase = value;
      notifyListeners();
    }
  }

  void updateCount() {
    _counter += increase ? 1 : -1;
    notifyListeners();
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ComputedBuilder(
              computed: (context) => context.listen(model).counter,
              builder: (context, counter, _) {
                return Text('Counter: $counter');
              },
            ),
            const SizedBox(height: 64),
            ComputedBuilder(
              computed: (context) => context.listen(model).increase,
              builder: (context, increase, _) {
                var direction = increase ? 'Increasing' : 'Decreasing';
                return Text('Direction: $direction');
              },
            ),
            ComputedBuilder(
              computed: (context) => context.listen(model).increase,
              builder: (context, increaseValue, _) {
                return Switch(
                  value: increaseValue,
                  onChanged: (value) => model.increase = value,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.updateCount(),
        child: ComputedBuilder(
          computed: (context) => context.listen(model).increase,
          builder: (context, increase, _) {
            return Icon(
              increase ? Icons.arrow_upward : Icons.arrow_downward,
            );
          },
        ),
      ),
    );
  }
}
```

</td>
</tr>
</table>
