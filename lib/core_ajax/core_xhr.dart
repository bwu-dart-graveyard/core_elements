// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS

/**
 * [:d-core-xhr:] can be used to perform XMLHttpRequests.
 *
 *     <d-core-xhr id="xhr"></d-core-xhr>
 *     ...
 *     this.$['xhr'].request({'url': url, 'params': params, 'callback': callback});
 *
 * (egrimes) TODO:  Match dart's HttpRequest naming?
 */

library core_elements.core_xhr;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';

typedef void ReadyStateCallback(response, dom.HttpRequest xhr);

@CustomTag('d-core-xhr')
class CoreXhr extends PolymerElement {

  CoreXhr.created() : super.created();

  /**
   * Sends a HTTP request to the server and returns the XHR object.
   *
   * inOptions
   *    inOptions.url (String) The url to which the request is sent.
   *    inOptions.method (String) The HTTP method to use, default is GET.
   *    inOptions.sync (bool) By default, all requests are sent asynchronously.
   *        To send synchronous requests, set to true.
   *    inOptions.params (dynamic) Data to be sent to the server.
   *    inOptions.body (dynamic) The content for the request body for POST method.
   *    inOptions.headers (dynamic) HTTP request headers.
   *    inOptions.responseType (String) The response type. Default is 'text'.
   *    inOptions.withCredential (bool) Whether or not to send credentials on the request. Default is false.
   *    inOptions.callback (dynamic)Called when request is completed.
   * returns XHR object (dynamic).
   *
   */
  request(Map options) {
    var xhr = new dom.HttpRequest();
    var url = options['url'];
    var method = _valueOrDefault(options['method'], 'GET');
    var async =  _valueOrDefault(options['sync'], true);
    var params = this._toQueryString(_valueOrDefault(options['params'],{}));
    if (params.isNotEmpty && method == 'GET') {
      url += (url.indexOf('?') > 0 ? '&' : '?') + params;
    }

    var xhrParams = this.isBodyMethod(method) ? (options['body'] != null ? options['body'] : params) : null;

    xhr.open(method, url, async: async);
    if (options.containsKey('responseType')) {
      xhr.responseType = options['responseType'];
    }
    if (options['withCredentials'] != null && options['withCredentials']) {
      xhr.withCredentials = true;
    }
    this._makeReadyStateHandler(xhr, options['callback']);
    this._setRequestHeaders(xhr, options['headers']);
    xhr.send(xhrParams);

    /**
     * TODO Figure out what to do in the case of the polymer.js "synchronous"
     * mode.
     * if (!async) {
     *     xhr.onreadystatechange(xhr);
     *   }
     *
     */

    return xhr;
  }

  String _toQueryString(Map params) {
    var r = [];
    for (var n in params.keys) {
      var v = params[n];
      n = Uri.encodeComponent(n);
      r.add(v == null ? n : (n + '=' + Uri.encodeComponent(v)));
    }
    var buffer = new StringBuffer();
    r.forEach((i){
      buffer.write(i);
      buffer.write('&');
    });
    var qs = buffer.toString();
    if(qs.endsWith('&')){
      qs = qs.substring(0, qs.length - 1);
    }
    return qs;
  }

  bool isBodyMethod(String method) {
    switch(method.toUpperCase()) {
      case 'POST':
      case 'PUT':
      case 'DELETE':
        return true;
      default:
        return false;
    }
  }

  void _makeReadyStateHandler(dom.HttpRequest xhr, ReadyStateCallback callback) {
    var sub;
    sub = xhr.onReadyStateChange.listen((_) {
      if (xhr.readyState == 4 && callback != null) {
        callback(xhr.response, xhr);
        sub.cancel();
      }
    });
  }

  void _setRequestHeaders(dom.HttpRequest xhr, Map headers) {
    if (headers != null) {
      for (var name in headers.keys) {
        xhr.setRequestHeader(name, headers[name]);
      }
    }
  }

  _valueOrDefault(value, defaultValue){
    if(value == null) return defaultValue;
    if(value is String && value.isEmpty) return defaultValue;
    return value;
  }
}
