import 'package:flutter/material.dart';
import 'package:flutter_styled/flutter_styled.dart';

void main() {
  runApp(MaterialApp(home: HelloPage()));
}

class HelloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Styled(
        styles: [
          .backgroundColor(Colors.red),
          .padding(.all(16)),
          .textStyle(color: Colors.white, fontSize: 100),
          .onSmall([
            .backgroundColor(Colors.lightBlue),
            .textStyle(fontSize: 18),
          ]),
          .center(),
        ],
        child: Text('Hello styled world!'),
      ),
    );
  }
}
