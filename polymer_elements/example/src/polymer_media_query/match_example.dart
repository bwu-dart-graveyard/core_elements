// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see 
// the AUTHORS file for details. All rights reserved. Use of this source code is 
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project, 
// http://www.polymer-project.org/. 

library polymer_elements.polymer_media_query.match_example;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

@CustomTag('match-example')
class MatchExample extends PolymerElement {
  MatchExample.created() : super.created();

  final _logger = new Logger('match-example');

  @observable String mquery = 'min-width: 600px';
  @observable bool qmatches = false;
}
