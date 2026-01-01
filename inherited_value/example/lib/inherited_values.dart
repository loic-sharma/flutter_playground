import 'package:flutter/material.dart';
import 'package:inherited_value/inherited_value.dart';

void main() {
  runApp(MaterialApp(home: CounterScreen()));
}

class AppColors {
  const AppColors({required this.buttonColor});
  final Color buttonColor;
}

class CounterModel {
  const CounterModel({required this.increment});
  final VoidCallback increment;
}

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
