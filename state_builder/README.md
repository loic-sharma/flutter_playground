# StateBuilder

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
  runApp(MaterialApp(home: CounterPage()));
}

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Count: $counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => counter++);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

```


</td>
<td>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CounterPage()));
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      create: () => 0,
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
```

</td>
</tr>
</table>

# StateBuilder with multiple values

> [!IMPORTANT]  
> This section uses hypothetical syntax for Dart record
> spreading.

```dart
import 'package:flutter/material.dart';
import 'package:state_builder/state_builder.dart';

void main() {
  runApp(MaterialApp(home: CounterPage()));
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      create: (context) => (counter: 0, increase: true),
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
                    setState((...state, increase: value));
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState((...state, counter: state.counter + 1));
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
```
