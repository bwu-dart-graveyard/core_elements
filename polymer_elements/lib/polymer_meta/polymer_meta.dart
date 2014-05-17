// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.

library polymer_elements.polymer_meta;

import 'dart:html';
import 'package:polymer/polymer.dart';

  @CustomTag('polymer-meta')
  class PolymerMeta extends PolymerElement {

    static Map<String, Map<String, PolymerMeta>> _metaData = {};

    static ObservableMap<String, List<PolymerMeta>> _metaArray = new ObservableMap<String, List<PolymerMeta>>();

    final String SKIP_ID = 'meta';

    @published
    String label;

    @published
    String type = 'default';

    //TODO (egrimes) Polymer.js sets always prepare to true, but this has strange effects in polymer.dart
    //bool get alwaysPrepare => true;

    PolymerMeta.created() : super.created() {
      _metaArray.changes.listen((e) {
        e.forEach((e) {
          if(e is MapChangeRecord && e.key == this.type) {
            notifyPropertyChange(#list, e.oldValue, e.newValue);
          }
        });
      });
    }

    void ready() {
      super.ready();

      this.idChanged(null);
    }

    List<PolymerMeta> get metaArray {
      var t = this.type;
      if (_metaArray[t] == null) {
        _metaArray[t] = toObservable([]);
      }
      return _metaArray[t];
    }

    Map<String, PolymerMeta> get metaData {
      var t = this.type;
      if (_metaData[t] == null) {
        _metaData[t] = {};
      }
      return _metaData[t];
    }

    void idChanged(String old) {
      if (this.id != null && this.id.isNotEmpty && this.id != SKIP_ID) {
        this._unregister(this, old);
        this.metaData[this.id] = this;
        this.metaArray.add(this);
      }
    }

    void _unregister(PolymerMeta meta, String id) {
      _metaData.remove(id != null ? id : meta);
      _metaArray.remove(meta);
    }

    @published
    List<PolymerMeta> get list => this.metaArray;

    TemplateElement get archetype => this.querySelector('template');

    PolymerMeta byId(id) {
      return this.metaData[id];
    }

    ElementList<PolymerMeta> get childMetas => this.querySelectorAll(this.localName);
  }
