// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This example shows how to show the text 'Hello, world.' using the underlying
// render tree.

import 'dart:ui';

import 'package:container2/component_box.dart';
import 'package:flutter/rendering.dart';

void main() {
  runRenderApp(MyApp());
}

class MyApp extends RenderComponentBox {
  int _counter = 0;

  RenderBox? _app;
  RenderParagraph? _paragraph;

  void onIncrement() {
    _counter++;
    _paragraph?.text = TextSpan(text: 'Counter: $_counter');
  }

  @override
  RenderBox? build() {
    return _app ??= RenderStack(
      textDirection: TextDirection.ltr,
      children: [
        RenderPositionedBox(
          alignment: .center,
          child: _paragraph ??= RenderParagraph(
            TextSpan(text: 'Counter: $_counter'),
            textDirection: .ltr,
          ),
        ),
        RenderPositionedBox(
          alignment: .bottomRight,
          child: RenderPadding(
            padding: const .all(16.0),
            child: MyButton(
              onPressed: onIncrement,
              child: RenderParagraph(
                TextSpan(text: '+ Increment'),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyButton extends RenderComponentBox
    with RenderComponentBoxWithChildMixin<RenderBox> {
  MyButton({required this.onPressed, RenderBox? child}) {
    this.child = child;
  }

  final VoidCallback onPressed;
  RenderBox? _button;
  RenderObjectWithChildMixin? _childParent;

  @override
  void didUpdateChild(RenderBox? oldChild) {
    _childParent?.child = child;
  }

  @override
  RenderBox? build() {
    return _button ??= RenderPointerListener(
      onPointerDown: (event) => onPressed(),
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
