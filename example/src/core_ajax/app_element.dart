// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS

library app_element;

import 'package:polymer/polymer.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {

  @observable
  List entries;

  AppElement.created() : super.created();

  responseReceived(e, detail, node){
    entries = detail['response']['feed']['entry'];
  }

}