import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HelloPage()));
}

class HelloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                Widget result = Center(
                  child: Text(
                    'Hello world',
                  ),
                );

                if (constraints.maxWidth < 400) {
                  result = ColoredBox(
                    color: Colors.lightBlue,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      child: result,
                    ),
                  );
                }
                return result;
              },
            ),
          ),
        ),
      ),
    );
  }
}
