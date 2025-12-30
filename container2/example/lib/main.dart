import 'package:container2/container2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyPage()));
}

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Color? color;

  @override
  Widget build(BuildContext context) {
    Container2();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: <Widget>[
            Text('Container:'),
            Container(color: color, child: Counter()),

            SizedBox(height: 20),

            Text('Container2:'),
            Container2(color: color, child: Counter()),

            SizedBox(height: 20),

            TextButton(
              onPressed: () => setState(() {
                color = switch (color) {
                  null => Colors.red,
                  _ => null,
                };
              }),
              child: const Text('Toggle color'),
            ),

            SizedBox(height: 20),

            Text(
              'This example shows how Container can lose state.'
              '\n'
              '\n'
              'Press +1 a few times and then toggle the color.'
              '\n'
              '\n'
              'Notice how Container2 does not lose state.',
            ),
          ],
        ),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $count'),
        TextButton(
          onPressed: () => setState(() => count++),
          child: const Text('+1'),
        ),
      ],
    );
  }
}
