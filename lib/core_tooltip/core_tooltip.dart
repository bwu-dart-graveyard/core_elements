// Copyright (c) 2013, the core_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.


/**
 * The `core-tooltip` element creates a hover tooltip centered for the content
 * it contains. It can be positioned on the top|bottom|left|right of content using
 * the `position` attribute.
 *
 * To include HTML in the tooltip, include the `tip` attribute on the relevant
 * content.
 *
 * Example:
 *
 *     <core-tooltip label="I'm a tooltip">
 *       <span>Hover over me.</span>
 *     </core-tooltip>
 *
 * Example - positioning the tooltip to the right:
 *
 *     <core-tooltip label="I'm a tooltip to the right" position="right">
 *       <polymer-ui-icon-button icon="drawer"></polymer-ui-icon-button>
 *     </core-tooltip>
 *
 * Example - no arrow and showing by default:
 *
 *     <core-tooltip label="Tooltip with no arrow and always on" noarrow show>
 *       <img src="image.jpg">
 *     </core-tooltip>
 *
 * Example - rich tooltip using the `tip` attribute:
 *
 *     <core-tooltip>
 *       <div>Example of a rich information tooltip</div>
 *       <div tip>
 *         <img src="profile.jpg">Foo <b>Bar</b> - <a href="#">@baz</a>
 *       </div>
 *     </core-tooltip>
 *
 */

library core_elements.core_tooltip;

import 'package:polymer/polymer.dart';

import 'package:core_elements/tools/dom.dart' as domtools;

@CustomTag('core-tooltip')
class CoreTooltip extends PolymerElement {
  CoreTooltip.created() : super.created();

  /**
    * A simple string label for the tooltip to display. To display a rich
    * that includes HTML, use the `tip` attribute on the content.
    *
    * @attribute noarrow
    * @type string
    * @default null
    */
  @published String label;

  /**
    * If true, the tooltip an arrow pointing towards the content.
    *
    * @attribute noarrow
    * @type boolean
    * @default false
    */
  @published bool noarrow = false;

  /**
    * If true, the tooltip displays by default.
    *
    * @attribute show
    * @type boolean
    * @default false
    */
  @published bool show = false;

  /**
    * Positions the tooltip to the top, right, bottom, left of its content.
    *
    * @attribute position
    * @type string
    * @default 'bottom'
    */
  @published String position = 'bottom';

  void attached() {
    try {
    super.attached();
      setPosition();
    } catch(e) {
      print('attached: $e');
    }
  }

  void labelChanged(oldVal) {
    // Run if we're not after attached().
    if (oldVal != null) {
      setPosition();
    }
  }

  void setPosition() {
    var controlWidth = this.clientWidth;
    var controlHeight = this.clientHeight;

    var styles = ($['tooltip'].getComputedStyle());
    var toolTipWidth = domtools.parseDouble(styles.width);
    var toolTipHeight = domtools.parseDouble(styles.height);

    switch (this.position) {
      case 'top':
      case 'bottom':
        $['tooltip'].style.left = '${(controlWidth - toolTipWidth) / 2}px';
        break;
      case 'left':
      case 'right':
        $['tooltip'].style.top = '${(controlHeight - toolTipHeight) / 2}px';
        break;
    }
  }
}
