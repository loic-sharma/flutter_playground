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
              builder: (context, counter, _) => Text('Counter: $counter'),
            ),
            const SizedBox(height: 64),
            ComputedBuilder(
              computed: (context) => context.listen(model).increase ? 'Increasing' : 'Decreasing',
              builder: (context, increase, _) => Text('Direction: $increase'),
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
          computed: (context) => context.listen(model).increase ? Icons.arrow_upward : Icons.arrow_downward,
          builder: (context, icon, _) => Icon(icon),
        ),
      ),
    );
  }
}
