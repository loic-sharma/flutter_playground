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

  String get direction => _increase ? 'increasing' : 'decreasing';

  IconData get icon => _increase ? Icons.add : Icons.remove;

  void updateCount() {
    _counter += increase ? 1 : -1;
    notifyListeners();
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Counter: ${model.counter}'),
                SizedBox(height: 64),
                Text('Direction: ${model.direction}'),
                Switch(
                  value: model.increase,
                  onChanged: (value) => model.increase = value,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: model.updateCount,
            child: Icon(model.icon),
          ),
        );
      },
    );
  }
}
```


</td>
<td>

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:computed_listenable/computed_listenable.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

final model = Model();

class Model {
  ValueListenable<int> get counter => _counter;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  final ValueNotifier<bool> increase = ValueNotifier<bool>(true);

  ValueListenable<String> get direction => _direction;
  late final _direction = ComputedListenable<String>((context) {
    return context.watch<bool>(increase) ? 'increasing' : 'decreasing';
  });

  ValueListenable<IconData> get icon => _icon;
  late final _icon = ComputedListenable<IconData>((context) {
    return context.watch<bool>(increase) ? Icons.add : Icons.remove;
  });

  void updateCount() {
    _counter.value += increase.value ? 1 : -1;
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
            Text('Counter: ${context.watch(model.counter)}'),
            SizedBox(height: 64),
            Text('Direction: ${context.watch(model.direction)}'),
            Switch(
              value: context.watch(model.increase),
              onChanged: (value) => model.increase.value = value,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.updateCount,
        child: Icon(context.watch(model.icon)),
      ),
    );
  }
}
```

</td>
</tr>
</table>
