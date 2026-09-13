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

final counter = ValueNotifier<int>(0);

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final ValueNotifier<bool> isEven;

  @override
  void initState() {
    super.initState();
    isEven = ValueNotifier<bool>(counter.value % 2 == 0);
    counter.addListener(_handleCounterChanged);
  }

  void _handleCounterChanged() {
    isEven.value = counter.value % 2 == 0;
  }

  @override
  void dispose() {
    counter.removeListener(_handleCounterChanged);
    isEven.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: counter,
            builder: (context, counter, _) {
              return Text('Counter: $counter');
            },
          ),
          ValueListenableBuilder(
            valueListenable: isEven,
            builder: (context, isEven, _) {
              return Text('Is even: $isEven');
            },
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
```


</td>
<td>

```dart
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
```

</td>
</tr>
</table>
