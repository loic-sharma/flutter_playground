import 'package:flutter/material.dart';
import 'package:computed_listenable/computed_listenable.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

final counter = ValueNotifier(0);

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: counter,
            builder: (context, value, _) => Text('Count: $value'),
          ),
          ComputedBuilder(
            computed: (context) => context.watch(counter) % 2 == 0,
            builder: (context, isEven, _) => Text('Is even: $isEven'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        child: Icon(Icons.add),
      ),
    );
  }
}
