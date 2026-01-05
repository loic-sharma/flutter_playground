int calculate() {
  Builder((int a) => print(a));

  return 6 * 7;
}

class Test {
  final String test = 'test';
  final String test2 = 'test';
}


class Builder {
  Builder(this.callback);
  final void Function(int a) callback;
}
