// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// This work is a port of the core-elements from the Polymer project,
// http://www.polymer-project.org/.
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS


/**
 * [:core-collapse:] creates a collapsible block of content.  By default, the content
 * will be collapsed.  Use [:opened:] to show/hide the content.
 *
 *     <button on-click="{{toggle}}">toggle collapse</button>
 *
 *     <core-collapse id="collapse"></core-collapse>
 *       ...
 *     </core-collapse>
 *
 *     ...
 *
 *     toggle: function() {
 *       $[collapse].toggle();// || !_inDocument) {
 *     }
 */
library core_elements.core_collapse;

import 'dart:async' as async;
import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

@CustomTag('d-core-collapse')
class CoreCollapse extends PolymerElement {
  CoreCollapse.created() : super.created();

  final _logger = new Logger('d-core-collapse');

  /**
   * The target element.
   */
  @published dom.HtmlElement target;

  /**
   * If true, the orientation is horizontal; otherwise is vertical.
   */
  @published bool horizontal = false;

  /**
   * Set opened to true to show the collapse element and to false to hide it.
   */
  @published bool opened = false;

  /**
   * Collapsing/expanding animation duration in second.
   */
  @published double duration = 0.33;

  /**
   * If true, the size of the target element is fixed and is set
   * on the element.  Otherwise it will try to
   * use auto to determine the natural size to use
   * for collapsing/expanding.
   */
  @published bool fixedSize = false;

  var _size = null;
  async.StreamSubscription _transitionEndListener;
  String _dimension = "";
  bool _hasClosedClass = false;
  bool _afterInitialUpdate = false;
  bool _isTargetReady = false;

  @override
  void ready() {
    super.ready();
    if (target == null) {
      target = this;
    }
  }

  @override
  void attached() {
    _logger.finest('attached');

    super.attached();
    new async.Future(() => _afterInitialUpdate = true);
  }

  @override
  void detached() {
    _logger.finest('detached');

    if (target != null) {
      removeListeners(target);
    }
    super.leftView();
  }

  void targetChanged(dom.HtmlElement old) {
    _logger.finest('targetChanged $target');

    if (old != null) {
      removeListeners(old);
    }

    if (target == null) {
      return;
    }

    _isTargetReady = (target != null);

    if (target != this) {
      installControllerStyles();
    }

    classes.toggle('core-collapse-closed', target != this);
    target.style.overflow = 'hidden';
    horizontalChanged();
    addListeners(target);
    // set core-collapse-closed class initially to hide the target
    toggleClosedClass(true);
    update();
  }

  void addListeners(dom.HtmlElement node) {
    _logger.finest('addListeners');

    if (_transitionEndListener != null) {
      _transitionEndListener.cancel();
    }
    _transitionEndListener = node.onTransitionEnd.listen((d) => transitionEnd(d)
        );
  }

  void removeListeners(dom.HtmlElement node) {
    _logger.finest('removeListeners');

    if (_transitionEndListener != null) {
      _transitionEndListener.cancel();
    }
    _transitionEndListener = null;
  }

  void horizontalChanged() {
    _logger.finest('horizontalChanged');

    if (horizontal) {
      _dimension = 'width';
    } else {
      _dimension = 'height';
    }
  }

  void openedChanged(e) {
    _logger.finest('openChanged');

    update();
  }

  /**
   * Toggle the opened state.
   */
  void toggle() {
    _logger.finest("toggle '${id}'");

    opened = !opened;
  }

  void setTransitionDuration(double duration) {
    _logger.finest('setTransitionDuration');

    var s = target.style;
    if (duration != null && duration != 0) {
      _logger.finest("setTransitionDuration - ${_dimension} ${duration}s");
      s.transition = '${_dimension} ${duration}s';
    } else {
      _logger.finest("setTransitionDuration - duration 0ms");
      s.transition = null;
      new async.Future(() => transitionEnd);
    }
  }

  void transitionEnd([e]) {
    _logger.finest('transitionEnd');

    if (opened && !fixedSize) {
      updateSize('auto', null);
    }
    setTransitionDuration(null);
    toggleClosedClass(!opened);
  }

  void toggleClosedClass(bool closed) {
    _logger.finest('toggleClosedClass');

    _hasClosedClass = closed;
    target.classes.toggle('core-collapse-closed', closed);
  }

  void updateSize(dynamic size, double duration, {bool forceEnd: false}) {
    _logger.finest('updateSize');

    setTransitionDuration(duration);
    var s = target.style;
    bool noChange = s.getPropertyValue(_dimension) == size;
    s.setProperty(_dimension, size.toString());
    // transitonEnd will not be called if the size has not changed
    if (forceEnd && noChange) {
      transitionEnd();
    }
  }

  void update() {
    _logger.finest('update');

    if (target == null) {
      return;
    }
    if (!_isTargetReady) {
      targetChanged(null);
    }
    horizontalChanged();
    if (opened) {
      show();
    } else {
      hide();
    }
  }

  void show() {
    _logger.finest('show');

    toggleClosedClass(false);
    // for initial update, skip the expanding animation to optimize
    // performance e.g. skip calcSize
    if (!_afterInitialUpdate) {
      transitionEnd();
      return;
    }
    var s;
    if (!fixedSize) {
      updateSize('auto', null);
      s = calcSize();
      updateSize(0, null);
    }
    new async.Future(() {
      if (_size != null) {
        s = _size;
      }
      updateSize(s, duration, forceEnd: true);
    });
  }

  void hide() {
    _logger.finest('hide');

    // don't need to do anything if it's already hidden
    if (_hasClosedClass && !fixedSize) {
      return;
    }
    if (fixedSize) {
      // save the size before hiding it
      _size = getComputedSize();
    } else {
      updateSize(calcSize(), null);
    }
    new async.Future(() {
      updateSize(0, duration);
    });
  }

  dynamic calcSize() {
    _logger.finest('calcSize');

    var cr = target.getBoundingClientRect();
    if (_dimension == 'width') {
      return '${cr.width}px';
    } else {
      return '${cr.height}px';
    }
  }

  String getComputedSize() {
    _logger.finest('getComputedSize');

    var cs = target.getComputedStyle();
    if (_dimension == 'width') {
      return cs.width;
    } else {
      return cs.height;
    }
  }
}
