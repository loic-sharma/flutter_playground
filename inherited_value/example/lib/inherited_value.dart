import 'package:flutter/material.dart';
import 'package:inherited_value/inherited_value.dart';

void main() {
  runApp(MaterialApp(home: MyScreen()));
}

class AppColors {
  AppColors({required this.buttonColor});
  final Color buttonColor;
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InheritedValue(
      create: () => AppColors(buttonColor: Colors.blue),
      child: Scaffold(
        body: Center(child: MyButton()),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppColors colors = InheritedValue.of<AppColors>(context);

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: colors.buttonColor),
      onPressed: () {},
      child: const Text('Hello world'),
    );
  }
}
