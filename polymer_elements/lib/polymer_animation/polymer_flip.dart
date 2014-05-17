// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.


library polymer_elements.polymer_flip;

import 'package:polymer/polymer.dart';
import 'polymer_animation.dart';

/**
 * A CSS property and value to use in a `<polymer-animation-keyframe>`.
 */
@CustomTag('polymer-flip')
class PolymerFlip extends PolymerAnimation {

  PolymerFlip.created(): super.created() {
    duration = '0.5';
  }

  @published
  String axis = 'x';

  @override
  void ready() {
    this.generate();
  }

  void axisChanged(old) {
    this.generate();
  }

  void generate() {
    var isY = this.axis == 'y' || this.axis == 'Y';
    var rotate = isY ? 'rotateY' : 'rotateX';
    var transZ = isY ? '150px' : '50px';
    this.keyframes = [{
        'offset': 0,
        'transform':
            'perspective(400px) translateZ(0px) ${rotate}(0deg) scale(1)'
      }, {
        'offset': 0.4,
        'transform':
            'perspective(400px) translateZ(${transZ}) ${rotate}(170deg) scale(1)'
      }, {
        'offset': 0.5,
        'transform':
            'perspective(400px) translateZ(${transZ}) ${rotate}(190deg) scale(1)'
      }, {
        'offset': 0.8,
        'transform':
            'perspective(400px) translateZ(0px) ${rotate}(360deg) scale(.95)'
      }, {
        'offset': 1,
        'transform':
            'perspective(400px) translateZ(0px) ${rotate}(360deg) scale(1)'
      }];
  }
}
