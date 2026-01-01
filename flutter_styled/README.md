# Styled

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
  runApp(MaterialApp(home: HelloPage()));
}

class HelloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.red,
        child: Padding(
          padding: .all(16),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                Widget result = Center(
                  child: Text('Hello world'),
                );

                if (constraints.maxWidth < 400) {
                  result = ColoredBox(
                    color: Colors.lightBlue,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 18),
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
```


</td>
<td>

```dart
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
            .textStyle(color: Colors.white, fontSize: 18),
          ]),
          .center(),
        ],
        child: Text('Hello styled world!'),
      ),
    );
  }
}
```

</td>
</tr>
</table>
