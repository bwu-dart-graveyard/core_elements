// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS


library core_elements.core_collapse_toggle;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'core_collapse.dart';

@CustomTag('d-core-collapse-toggle')
class CoreCollapseToggle extends PolymerElement {
  CoreCollapseToggle.created() : super.created();

  final _logger = new Logger('d-core-collapse-button');

  /**
   * The selector for the target polymer-collapse element.
   */
  @published CoreCollapse target;

  void handleClick([e]) {
    if (target != null) {
      target.toggle();
    }else {
      print('t is null!!!');
    }
  }
}
