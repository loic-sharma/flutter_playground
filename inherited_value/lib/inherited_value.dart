/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

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
  CounterModel model = CounterModel(counter: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawInheritedValue(
        value: model,
        updateShouldNotify: (oldValue, newValue)
          => oldValue.counter != newValue.counter,
        child: Center(
          child: DisplayCounter(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            model = CounterModel(counter: model.counter + 1);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DisplayCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterModel model = CounterModel.of(context);
    return Text('Count: ${model.counter}');
  }
}