import 'package:container2/container2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyContainer(child: MyStateLoser()),
            Text(
              'This example shows how a loss of state can happen when Container changes the widget tree. Press +1 a few times and then toggle the color.',
            ),
          ],
        ),
      ),
    );
  }
}

class MyContainer extends StatefulWidget {
  const MyContainer({super.key, required this.child});

  final Widget child;

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              color = color == null ? Colors.red : null;
            });
          },
          child: const Text('Toggle color'),
        ),
        // TRY ME: Switch this to Container.
        // Container(color: color, width: 100, child: widget.child),
        Container2(color: color, width: 100, child: widget.child),
      ],
    );
  }
}

class MyStateLoser extends StatefulWidget {
  const MyStateLoser({super.key});

  @override
  State<MyStateLoser> createState() => _MyStateLoserState();
}

class _MyStateLoserState extends State<MyStateLoser> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('You have pressed the button $count times.'),
        TextButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Text('+1'),
        ),
      ],
    );
  }
}
