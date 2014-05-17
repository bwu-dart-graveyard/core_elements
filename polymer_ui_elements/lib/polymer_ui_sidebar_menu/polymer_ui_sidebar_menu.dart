// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.
library polymer_ui_elements.polymer_ui_sidebar_menu;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart' show CustomTag, PolymerElement, published,
ChangeNotifier, reflectable; // TODO remove ChangeNotifier, reflectable when bug is solved
// https://code.google.com/p/dart/issues/detail?id=13849
// (https://code.google.com/p/dart/issues/detail?id=15095)
import 'package:logging/logging.dart' show Logger;
import 'package:polymer_ui_elements/polymer_ui_menu/polymer_ui_menu.dart' show PolymerUiMenu;

/**
 * polymer-ui-sidebar-menu is a polymer-menu styled to look like a sidebar menu.
 * The sidebar menu is styled with an arrow pointing to the selected menu item.
 * Use it in conjunction with polymer-ui-menu-item.
 *
 * Example:
 *
 *     <polymer-ui-sidebar-menu selected="0">
 *       <polymer-ui-menu-item icon="menu" label="Home"></polymer-ui-menu-item>
 *       <polymer-ui-menu-item icon="menu" label="Explore"></polymer-ui-menu-item>
 *       <polymer-ui-menu-item icon="menu" label="Favorites"></polymer-ui-menu-item>
 *     </polymer-ui-sidebar-menu>
 */

@CustomTag('polymer-ui-sidebar-menu')
class PolymerUiSidebarMenu extends PolymerUiMenu {
  PolymerUiSidebarMenu.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('polymer-ui-sidebar-menu');

  @published String label = '';

  @published var selectedItem;

  @override
  void enteredView() {
    super.enteredView();
    this.on['polymer-select'].listen((dom.CustomEvent e) {
      if(e.detail['isSelected'] == true) {
        selectedItem = e.detail['item'];
      }
    });
  }
}
