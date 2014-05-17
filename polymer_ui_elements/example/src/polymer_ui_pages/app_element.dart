// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see 
// the AUTHORS file for details. All rights reserved. Use of this source code is 
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project, 
// http://www.polymer-project.org/. 
library polymer_ui_elements.polymer_ui_pages.app_element;

import 'dart:html' show document;
import 'package:polymer/polymer.dart' show CustomTag, PolymerElement;
import 'package:logging/logging.dart' show Logger;

@CustomTag('app-element')
class AppElement extends PolymerElement {
  AppElement.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('app-element');
  
  @override
  void enteredView() {
    super.enteredView();
    document.onClick.listen((e) {
      var p = shadowRoot.querySelector('polymer-ui-pages');
      if(p.selected is int) {
        p.selected = (p.selected + 1) % 5;
      } else {
        p.selected = 0;
      }
    });
  }
}
