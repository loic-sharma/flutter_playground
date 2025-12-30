import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:render_box_builder/render_box_builder.dart';


typedef ChildWidgetBuilder = Widget Function(BuildContext context, Widget child);

class If extends StatefulWidget {
  const If({
    super.key,
    required this.condition,
    ChildWidgetBuilder? thenBuilder,
    ChildWidgetBuilder? elseBuilder,
    required this.child,
  }) : thenBuilder = thenBuilder ?? _defaultChildWidgetBuilder,
       elseBuilder = elseBuilder ?? _defaultChildWidgetBuilder;

  final bool condition;
  final ChildWidgetBuilder thenBuilder;
  final ChildWidgetBuilder elseBuilder;
  final Widget child;

  @override
  State<If> createState() => _IfState();
}

class _IfState extends State<If> {
  final Map<_InheritedIfSlot, RenderObjectWithChildMixin<RenderBox>> slots = {};

  void _updateSlot(
    _InheritedIfSlot slot,
    RenderObjectWithChildMixin<RenderBox>? value,
  ) {
    setState(() {
      if (value == null) {
        slots.remove(slot);
      } else {
        slots[slot] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget result = _RawIf(
      condition: widget.condition,
      thenChildRoot: slots[_InheritedIfSlot.thenRoot]?.child,
      thenChildLeaf: slots[_InheritedIfSlot.thenLeaf],
      elseChildRoot: slots[_InheritedIfSlot.elseRoot]?.child,
      elseChildLeaf: slots[_InheritedIfSlot.elseLeaf],
      child: widget.child,
    );
    result = widget.elseBuilder(context, result);
    result = widget.thenBuilder(context, result);

    return _InheritedIfData(
      updateSlot: _updateSlot,
      child: result,
    );
  }
}

class _SnoopWidget extends Widget {
  const _SnoopWidget({
    required this.parentSlot,
    this.childSlot,
    required this.child,
  });

  final _InheritedIfSlot parentSlot;
  final _InheritedIfSlot? childSlot;
  final Widget child;

  @override
  Element createElement() => _SnoopElement(this);
}

class _SnoopElement extends ComponentElement {
  // TODO: Replace Proxy with custom widget type
  _SnoopElement(_SnoopWidget super.widget);

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _updateRenderIf();
  }

  @override
  void update(covariant Widget newWidget) {
    super.update(newWidget);
    _updateRenderIf();
  }

  @override
  Widget build() => (widget as _SnoopWidget).child;

  void _updateRenderIf() {
    final widget = this.widget as _SnoopWidget;
    final renderIf = findAncestorRenderObjectOfType<RenderIf>();
    final parentLeaf = findAncestorRenderObjectOfType<RenderObjectWithChildMixin<RenderBox>>();

    assert(renderIf != null);
    assert(parentLeaf != null);

    switch (widget.parentSlot) {
      case _InheritedIfSlot.thenSlot:
        renderIf!.thenChildLeaf = parentLeaf;
        break;
      case _InheritedIfSlot.elseSlot:
        renderIf!.elseChildLeaf = parentLeaf;
        break;
    }
  }

  /*
  @override
  void attachRenderObject(Object? slot) {
    final widget = this.widget as _SnoopWidget;
    assert(() {
      return widget.parentSlot != null || widget.childSlot != null;
    }());
    
    final renderIf = findAncestorRenderObjectOfType<RenderIf>()!;

    if (widget.parentSlot != null) {
      final parent = findAncestorRenderObjectOfType<RenderObjectWithChildMixin<RenderBox>>();
      switch (widget.parentSlot!) {
        case _InheritedIfSlot.thenLeaf:
          renderIf.thenChildLeaf = parent;
          break;
        case _InheritedIfSlot.elseLeaf:
          renderIf.elseChildLeaf = parent;
          break;
        // TODO: Simplify _RenderIfSlot to just then and else?
        default:
          throw FlutterError('Invalid parent ${widget.parentSlot} for _SnoopWidget');
      }
    }

    if (widget.childSlot != null) {
      switch (widget.childSlot!) {
        case _InheritedIfSlot.thenRoot:
          renderIf.thenChildRoot = newRenderObject as RenderBox?;
          break;
        case _InheritedIfSlot.elseRoot:
          renderIf.elseChildRoot = newRenderObject as RenderBox?;
          break;
        default:
          throw FlutterError('Invalid child ${widget.childSlot} for _SnoopWidget');
      }
    }
  }

  @override
  Widget build() => (widget as ProxyWidget).child;
  */
}

class Foo2 extends SingleChildRenderObjectWidget {
  final _InheritedIfSlot? parentSlot;
  final _InheritedIfSlot? childSlot;

  @override
  Foo2Element createElement() {
    return Foo2Element(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) => RenderFoo2();
}

class Foo2Element extends SingleChildRenderObjectElement {
  Foo2Element(Foo2 super.widget);

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final widget = this.widget as _SnoopWidget;
    final renderIf = findAncestorRenderObjectOfType<RenderIf>()!;

    if (widget.childSlot != null) {
      switch (widget.childSlot!) {
        case _InheritedIfSlot.thenRoot:
          renderIf.thenChildRoot = child as RenderBox?;
          break;
        case _InheritedIfSlot.elseRoot:
          renderIf.elseChildRoot = child as RenderBox?;
          break;
        default:
          throw FlutterError('Invalid child ${widget.childSlot} for _SnoopWidget');
      }
    }
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject as RenderObjectWithChildMixin<RenderObject>;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject as RenderObjectWithChildMixin<RenderObject>;
    assert(slot == null);
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

class RenderFoo2 extends RenderProxyBox {
  RenderFoo2();
}

class _RawIf extends SingleChildRenderObjectWidget {
  const _RawIf({
    required this.condition,
    this.thenChildRoot,
    this.thenChildLeaf,
    this.elseChildRoot,
    this.elseChildLeaf,
    required Widget super.child,
  });

  final bool condition;
  final RenderBox? thenChildRoot;
  final RenderObjectWithChildMixin<RenderBox>? thenChildLeaf;
  final RenderBox? elseChildRoot;
  final RenderObjectWithChildMixin<RenderBox>? elseChildLeaf;

  @override
  RenderIf createRenderObject(BuildContext context) {
    return RenderIf(
      condition: condition,
      thenChildRoot: thenChildRoot,
      thenChildLeaf: thenChildLeaf,
      elseChildRoot: elseChildRoot,
      elseChildLeaf: elseChildLeaf,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderIf renderObject) {
    renderObject
      ..condition = condition
      ..thenChildRoot = thenChildRoot
      ..thenChildLeaf = thenChildLeaf
      ..elseChildRoot = elseChildRoot
      ..elseChildLeaf = elseChildLeaf;
  }
}

class _InheritedIfData extends InheritedWidget {
  const _InheritedIfData({
    required this.updateSlot,
    required super.child,
  });

  final _UpdateInheritedSlotCallback updateSlot;

  static _InheritedIfData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedIfData>();
  }

  static _InheritedIfData of(BuildContext context) {
    final instance = maybeOf(context);
    assert(instance != null, 'No _InheritedIfData found in context');
    return instance!;
  }

  @override
  bool updateShouldNotify(covariant _InheritedIfData oldWidget) {
    return updateSlot != oldWidget.updateSlot;
  }
}

typedef _UpdateInheritedSlotCallback = void Function(
    _InheritedIfSlot slot,
    RenderObjectWithChildMixin<RenderBox>? value,
);

enum _InheritedIfSlot {
  thenSlot,
  elseSlot,
}

Widget _defaultChildWidgetBuilder(BuildContext context, Widget child) {
  return child;
}

class RenderIf extends RenderBoxBuilder
    with RenderBoxBuilderWithChildMixin<RenderBox> {
  RenderIf({
    required bool condition,
    RenderBox? thenChildRoot,
    RenderObjectWithChildMixin<RenderBox>? thenChildLeaf,
    RenderBox? elseChildRoot,
    RenderObjectWithChildMixin<RenderBox>? elseChildLeaf,
    RenderBox? child,
  }) : _condition = condition,
       _thenChildRoot = thenChildRoot,
       _thenChildLeaf = thenChildLeaf,
       _elseChildRoot = elseChildRoot,
       _elseChildLeaf = elseChildLeaf {
    this.child = child;
  }

  bool get condition => _condition;
  bool _condition;
  set condition (bool value) {
    if (_condition == value) return;
    _condition = value;
    markNeedsBuild();
  }

  RenderBox? get thenChildRoot => _thenChildRoot;
  RenderBox? _thenChildRoot;
  set thenChildRoot(RenderBox? value) {
    if (_thenChildRoot == value) return;
    _thenChildRoot = value;
    markNeedsBuild();
  }

  RenderObjectWithChildMixin<RenderBox>? get thenChildLeaf => _thenChildLeaf;
  RenderObjectWithChildMixin<RenderBox>? _thenChildLeaf;
  set thenChildLeaf(RenderObjectWithChildMixin<RenderBox>? value) {
    if (_thenChildLeaf == value) return;
    _thenChildLeaf = value;
    markNeedsBuild();
  }

  RenderBox? get elseChildRoot => _elseChildRoot;
  RenderBox? _elseChildRoot;
  set elseChildRoot(RenderBox? value) {
    if (_elseChildRoot == value) return;
    _elseChildRoot = value;
    markNeedsBuild();
  }

  RenderObjectWithChildMixin<RenderBox>? get elseChildLeaf => _elseChildLeaf;
  RenderObjectWithChildMixin<RenderBox>? _elseChildLeaf;
  set elseChildLeaf(RenderObjectWithChildMixin<RenderBox>? value) {
    if (_elseChildLeaf == value) return;
    _elseChildLeaf = value;
    markNeedsBuild();
  }

  bool debugAssertIsValid() {
    if (child == null) {
      return false;
    }

    if (thenChildRoot != null && thenChildLeaf == null) {
      return false;
    }
    if (elseChildRoot != null && elseChildLeaf == null) {
      return false;
    }
    return true;
  }

  RenderObjectWithChildMixin<RenderBox>? _currentLeaf;

  @override
  void didUpdateChild(RenderBox? oldChild) {
    if (_currentLeaf != null) {
      _currentLeaf!.child = child;
    }
  }

  @override
  RenderBox build() {
    assert(debugAssertIsValid());

    RenderBox? root;
    RenderObjectWithChildMixin<RenderBox>? leaf;
    if (_condition) {
      root = thenChildRoot;
      leaf = thenChildLeaf;
    } else {
      root = elseChildRoot;
      leaf = elseChildLeaf;
    }

    if (root == null || leaf == null) {
      if (_currentLeaf != null) {
        _currentLeaf!.child = null;
        _currentLeaf = null;
      }
      return child!;
    } else {
      if (_currentLeaf != leaf) {
        _currentLeaf?.child = null;
        leaf.child = child;
        _currentLeaf = leaf;
      }

      return root;
    }
  }
}
