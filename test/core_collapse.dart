// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.


library polymer_collapse.test;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:polymer/polymer.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart' show
    useHtmlEnhancedConfiguration;
import 'package:core_elements/core_collapse/core_collapse.dart' show
    CoreCollapse;

@initMethod
void main() {
  useHtmlEnhancedConfiguration();

  test("core-collapse", () {
    Duration delay = new Duration(milliseconds: 200);
    var done = expectAsync(() {});
    async.Timer.run(() {
      var c = dom.document.querySelector('#collapse') as CoreCollapse;
      // verify take attribute for opened is correct
      expect(c.opened, isTrue);
      new async.Future.delayed(delay, () {
        // get the height for the opened state
        var h = getCollapseComputedStyle().height;
        // verify the height is not 0px
        expect(h, isNot(equals('0px')));
        // close it
        c.opened = false;
        //c.deliverChanges();
        new async.Future.delayed(delay, () {
          // verify is closed
          expect(getCollapseComputedStyle().height, isNot(equals(h)));
          // open it
          c.opened = true;
          //c.deliverChanges();
          new async.Future.delayed(delay, () {
            // verify is opened
            expect(getCollapseComputedStyle().height, equals(h));
            done();
          });
        });
      });
    });
  });
}

dynamic getCollapseComputedStyle() {
  dom.HtmlElement b = dom.document.querySelector('#collapse');
  return b.getComputedStyle();
}
