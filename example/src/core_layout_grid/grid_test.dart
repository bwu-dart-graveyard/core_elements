// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.

library core_elements.example.core_layout_grid.grid_test;

import 'dart:html' as dom;
import 'package:observe/observe.dart' show ObservableList;
import 'package:logging/logging.dart' show Logger;
import 'package:polymer/polymer.dart';

@CustomTag('grid-test')
class GridTest extends PolymerElement {
  GridTest.created() : super.created();

  final _logger = new Logger('grid-test');

  @published List<List<int>> layout;
  @published ObservableList<dom.Node> xnodes;


  List<List<List<int>>> _arrangements =
    [[
      [1, 1, 1, 1],
      [2, 3, 3, 4],
      [2, 3, 3, 5]
    ], [
      [4, 3, 2],
      [5, 3, 2],
      [5, 1, 1]
    ], [
      [1, 1],
      [2, 3],
      [4, 3]
    ]];

  @observable int outputLayout = 0;

  @override
  void ready() {
    this.outputLayoutChanged(null);
  }

  @override
  void attached() {
    super.attached();
    // zoechi workaround for different behavior of nodes getter, which seems not to include the <d-core-layout-grid> and <style> tags in JS
    this.xnodes = new ObservableList<dom.Element>.from(this.shadowRoot.children.where(
        (dom.Element e) => e.localName != 'd-core-layout-grid' && e.localName != 'style'));
  }

  void outputLayoutChanged(old) {
    this.layout = this._arrangements[this.outputLayout];
  }

  void toggleLayout() {
    this.outputLayout = (this.outputLayout + 1) % this._arrangements.length;
  }

  void rotate(dom.MouseEvent e, detail, dom.HtmlElement target) {
    this.toggleLayout();
  }
}
