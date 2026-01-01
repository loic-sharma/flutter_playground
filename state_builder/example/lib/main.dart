import 'package:flutter/material.dart';
import 'package:state_builder/state_builder.dart';

void main() {
  runApp(MaterialApp(home: CounterPage()));
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      create: (context) => 0,
      builder: (context, int counter, SetState<int> setCounter) {
        return Scaffold(
          body: Center(child: Text('Count: $counter')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setCounter(counter + 1),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
