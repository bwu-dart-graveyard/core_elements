// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS


library core_ajax.test;

import "dart:html";
import "package:polymer/polymer.dart";
import "package:unittest/unittest.dart";
import "package:unittest/html_enhanced_config.dart";

@initMethod
void init() {
  useHtmlEnhancedConfiguration();

  test("core-ajax", () {
    var done = expectAsync(() {});
    var s = document.querySelector('d-core-ajax');
    s.addEventListener('core-response', (event) {
      expect(event.detail['response']['feed']['entry'].length, greaterThan(0));
      done();
    });
  });
}

