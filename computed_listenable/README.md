# ComputedListenable

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
    if (increase) {
      _counter++;
    } else {
      _counter--;
    }
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
    if (increase.value) {
      _counter.value++;
    } else {
      _counter.value--;
    }
  }

  void dispose() {
    _counter.dispose();
    increase.dispose();
    _direction.dispose();
    _icon.dispose();
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
            ValueListenableBuilder(
              valueListenable: model.counter,
              builder: (context, value, child) {
                return Text('Counter: $value');
              },
            ),
            SizedBox(height: 64),
            ValueListenableBuilder(
              valueListenable: model.direction,
              builder: (context, value, child) {
                return Text('Direction: $value');
              },
            ),
            ValueListenableBuilder(
              valueListenable: model.increase,
              builder: (context, value, child) => Switch(
                value: model.increase.value,
                onChanged: (value) => model.increase.value = value,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.updateCount,
        child: ValueListenableBuilder(
          valueListenable: model.icon,
          builder: (context, value, child) {
            return Icon(value);
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
