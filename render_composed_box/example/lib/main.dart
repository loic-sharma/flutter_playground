// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:render_composed_box/render_composed_box.dart';

void main() {
  runRenderApp(MyApp());
}

class MyApp extends RenderComposedBox {
  MyApp() {
    composedChild = _create();
  }

  late RenderParagraph _paragraph;
  int _counter = 0;

  void _onIncrement() {
    _counter++;
    _paragraph.text = TextSpan(text: 'Counter: $_counter');
  }

  RenderBox _create() {
    return RenderStack(
      textDirection: .ltr,
      children: [
        RenderPositionedBox(
          alignment: .center,
          child: _paragraph = RenderParagraph(
            TextSpan(text: 'Counter: $_counter'),
            textDirection: .ltr,
          ),
        ),
        RenderPositionedBox(
          alignment: .bottomRight,
          child: RenderPadding(
            padding: const .all(16.0),
            child: MyButton(
              onPressed: (event) => _onIncrement(),
              child: RenderParagraph(
                TextSpan(text: '+ Increment'),
                textDirection: .ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PaddingWrapper extends SingleChildRenderObjectWidget {
  const PaddingWrapper({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyButton(onPressed: (event) {});
  }
}

class MyButton extends RenderComposedBox
    with RenderComposedBoxWithChildMixin<RenderBox> {
  MyButton({
    required PointerDownEventListener onPressed,
    RenderBox? child,
  }) {
    composedChild = _create(
      onPressed: onPressed,
      child: child,
    );
  }

  late final RenderPointerListener _onPressedParent;

  PointerDownEventListener? get onPressed => _onPressedParent.onPointerDown;
  set onPressed(PointerDownEventListener? value) {
    _onPressedParent.onPointerDown = value;
  }

  late final RenderPadding _childParent;

  @override
  RenderBox? get child => _childParent.child;
  @override
  set child(RenderBox? value) {
    _childParent.child = value;
  }

  RenderBox _create({
    required PointerDownEventListener onPressed,
    required RenderBox? child,
  }) {
    return _onPressedParent = RenderPointerListener(
      onPointerDown: onPressed,
      child: RenderDecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0000FF),
          borderRadius: .circular(4.0),
        ),
        child: _childParent = RenderPadding(
          padding: const .all(16.0),
          child: child,
        ),
      ),
    );
  }
}

void runRenderApp(RenderBox root) {
  ViewRenderingFlutterBinding(root: root).scheduleFrame();
}

class ViewRenderingFlutterBinding extends RenderingFlutterBinding {
  ViewRenderingFlutterBinding({RenderBox? root}) : _root = root;

  @override
  void initInstances() {
    super.initInstances();
    assert(PlatformDispatcher.instance.implicitView != null);
    _renderView = initRenderView(PlatformDispatcher.instance.implicitView!);
    _renderView.child = _root;
    _root = null;
  }

  RenderBox? _root;

  @override
  RenderView get renderView => _renderView;
  late RenderView _renderView;

  RenderView initRenderView(FlutterView view) {
    final RenderView renderView = RenderView(view: view);
    rootPipelineOwner.rootNode = renderView;
    addRenderView(renderView);
    renderView.prepareInitialFrame();
    return renderView;
  }

  @override
  PipelineOwner createRootPipelineOwner() {
    return PipelineOwner(
      onSemanticsOwnerCreated: () {
        renderView.scheduleInitialSemantics();
      },
      onSemanticsUpdate: (SemanticsUpdate update) {
        renderView.updateSemantics(update);
      },
      onSemanticsOwnerDisposed: () {
        renderView.clearSemantics();
      },
    );
  }
}
