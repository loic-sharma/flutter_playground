import 'package:flutter/material.dart';
import 'package:state_builder/state_builder.dart';

void main() {
  runApp(MaterialApp(home: CounterPage()));
}

class CounterState {
  CounterState({required this.counter, required this.increase});

  final int counter;
  final bool increase;

  CounterState copyWith({int? counter, bool? increase}) {
    return CounterState(
      counter: counter ?? this.counter,
      increase: increase ?? this.increase,
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      create: (context) => CounterState(counter: 0, increase: true),
      builder: (context, state, setState) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text('Count: ${state.counter}'),
                Text('Increase:'),
                Switch(
                  value: state.increase,
                  onChanged: (value) {
                    setState(state.copyWith(increase: value));
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(state.copyWith(counter: state.counter + 1));
            },
            child: Icon(
              state.increase ? Icons.add : Icons.remove,
            ),
          ),
        );
      },
    );
  }
}
