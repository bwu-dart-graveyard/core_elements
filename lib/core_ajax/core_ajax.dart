// Copyright (c) 2014 The Dart core_elements Authors. All rights reserved.
// This code may only be used under the BSD style license found at https://github.com/bwu-dart/core_elements/blob/master/LICENSE
// The complete set of authors may be found at https://github.com/bwu-dart/core_elements/blob/master/AUTHORS
// This work is a port of the core-elements from the Polymer project,
// http://www.polymer-project.org/.
// Code distributed by Dart core_elements Authors as part of the Dart core_elements project is also
// subject to an additional IP rights grant found at https://github.com/bwu-dart/core_elements/blob/master/PATENTS


/**
 * The [:d-core-ajax:] element exposes `XMLHttpRequest` functionality.
 *
 *     <d-core-ajax
 *         auto
 *         url="http://gdata.youtube.com/feeds/api/videos/"
 *         params='{"alt":"json", "q":"chrome"}'
 *         handleAs="json"
 *         on-core-response="{{handleResponse}}"></d-core-ajax>
 *
 * With `auto` set to `true`, the element performs a request whenever
 * its `url` or `params` properties are changed.
 *
 * Note: The `params` attribute must be double quoted JSON.
 *
 * You can trigger a request explicitly by calling `go` on the
 * element.
 */

library core_elements.core_ajax;

import 'dart:async' as async;
import 'dart:convert' show JSON;
import 'dart:html' as dom;
import 'package:polymer/polymer.dart';

import 'package:core_elements/core_ajax/core_xhr.dart';

@CustomTag('d-core-ajax')
class CoreAjax extends PolymerElement {

  /**
   * Fired when a response is received.
   *
   * @event core-response
   */

  /**
   * Fired when an error is received.
   *
   * @event core-error
   */

  /**
   * Fired whenever a response or an error is received.
   *
   * @event core-complete
   */


  /**
   * The URL target of the request.
   */
  @published
  String url =  '';

  /**
   * Specifies what data to store in the [response] property, and
   * to deliver as [:event.response:] in [:response:] events.
   *
   * One of:
   *
   *    [:text:]: uses [:XHR.responseText:].
   *
   *    [:xml:]: uses [:XHR.responseXML:].
   *
   *    [:json:]: uses [:XHR.responseText:] parsed as JSON.
   *
   *    [:arraybuffer:] uses [:XHR.response:].
   *
   *    [:blob:] uses [:XHR.response:].
   *
   *    [:document:] uses [:XHR.response:].
   *
   */
  @published
  String handleAs = '';

  /**
   * If true, automatically performs an Ajax request when either [url] or [params] has changed.
   */
  @published
  bool auto = false;

  /**
   * Parameters to send to the specified URL, as JSON.
   */
  @published
  String params = '';

  /**
   * Returns the response object.
   */
  @published
  var response;

  /**
   * The HTTP method to use such as 'GET', 'POST', 'PUT', or 'DELETE'.
   * Default is 'GET'.'
   */
  String method = '';

  /**
   * HTTP request headers to send.
  *
   * Example:
  *
   *     <d-core-ajax auto url="http://somesite.com"
   *         headers='{"X-Requested-With": "XMLHttpRequest"}'
   *         handleAs="json"
   *         on-core-response="{{handleResponse}}">
   *     </d-core-ajax>
   */
  @published
  var headers;

  /**
   * Optional raw body content to send when method == "POST".
   *
   * Example:
   *
   *     <d-core-ajax method="POST" auto url="http://somesite.com"
   *         body='{"foo":1, "bar":2}'>
   *     </d-core-ajax>
   */
  Map body;

  /**
   * Content type to use when sending data.
   */
  @published
  String contentType = 'application/x-www-form-urlencoded';

  /**
   * Set the withCredentials flag on the request.
   */
  @published
  bool withCredentials = false;

  /**
   * Default values for use with the underlying core-xhr object. Useful for
   * sending payloads other than the default URL encoded form values.
   *
   * Example:
   *
   *     querySelector('polymer-ajax')
   *       ..xhrArgs = {'body': JSON.encode(jsonData)};
   */
  @published
  Map xhrArgs = {};

  async.Timer _goJob;

  CoreXhr _xhr;

  CoreAjax.created() : super.created();

  void ready() {
    super.ready();
    this._xhr = new dom.Element.tag('d-core-xhr');
  }

  void _receive(response, dom.HttpRequest xhr) {
    if (this._isSuccess(xhr)) {
      this._processResponse(xhr);
    } else {
      this._error(xhr);
    }
    this._complete(xhr);
  }

  bool _isSuccess(dom.HttpRequest xhr) {
    var status = xhr.status != null ? xhr.status : 0;
    return status == null ? false : (status >= 200 && status < 300);
  }

  void _processResponse(dom.HttpRequest xhr) {
    var response = this._evalResponse(xhr);
    this.response = response;
    this.fire('core-response', detail: {'response': response, 'xhr': xhr});
  }

  void _error(dom.HttpRequest xhr) {
    var response = '${xhr.status}: ${xhr.responseText}';
    this.fire('core-error', detail: {'response': response, 'xhr': xhr});
  }

  void _complete(dom.HttpRequest xhr) {
    this.fire('core-complete', detail: {'response': xhr.status, 'xhr': xhr});
  }

  /**
   * return Map (or String when JSON decoding failed)
   */
  dynamic _evalResponse(dom.HttpRequest xhr) {
    switch(this.handleAs) {
      case 'json':
        return _jsonHandler(xhr);
      case 'xml':
        return _xmlHandler(xhr);
      case 'text':  // TODO text didn't work, what is an actual test case?
        return _textHandler(xhr);
      case 'document':
        return _documentHandler(xhr);
      case 'blob':
        return _blobHandler(xhr);
      case 'arraybuffer':
        return _arraybufferHandler(xhr);

      default:
        return _textHandler(xhr);
    }
  }

  dom.Document _xmlHandler(dom.HttpRequest xhr){
    return xhr.responseXml;
  }

  String _textHandler(dom.HttpRequest xhr) {
    return xhr.responseText;
  }

  /**
   * return Map (or String when JSON decoding failed)
   */
  _jsonHandler(xhr) {
    var r = xhr.responseText;
    try {
      return JSON.decode(r);
    } catch (x) {
      return r;
    }
  }

  dom.Document _documentHandler(dom.HttpRequest xhr) {
    return xhr.response;
  }

  dom.Blob _blobHandler(dom.HttpRequest xhr) {
    return xhr.response;
  }

  _arraybufferHandler(dom.HttpRequest xhr) { // TODO what actual type is arraybuffer
    return xhr.response;
  }

  void urlChanged(old){
    if (this.handleAs.isEmpty) {
      var split = this.url.split('.');
      var ext;
      if(split.isNotEmpty){
        ext = split.last;
      }else {
        ext = 'text';
      }
      this.handleAs = ext;
//      switch (ext) {
//        case 'json':
//          this.handleAs = 'json';
//          break;
//        case 'xml':
//          this.handleAs = 'xml';
//          break;
//        // TODO how to handle the other cases (document, arraybuffer, blob)?
//        default:
//          this.handleAs = 'text';
//      }
    }
    this._autoGo();
  }

  void paramsChanged(old) {
    this._autoGo();
  }

  void autoChanged(old){
    this._autoGo();
  }

  // TODO(sorvell): multiple side-effects could call autoGo
  // during one micro-task, use a job to have only one action
  // occur
  void _autoGo() {
    if(_goJob != null){
      _goJob.cancel();
    }
    _goJob = new async.Timer(Duration.ZERO, go);
  }

  /**
   * Performs an Ajax request to the specified URL.
  *
   * @method go
   */
  bool go() {
    var args = xhrArgs;
    // TODO(sjmiles): we may want XHR to default to POST if body is set
    //if (this.method == 'POST') {
    if(this.body != null) {
      args['body'] = this.body;
    }
    //}
    args['params'] = this.params;
    if (args['params'] is String && args['params'].isNotEmpty) {
      args['params'] = JSON.decode(args['params']);
    }
    if(this.headers != null) {
      args['headers'] = this.headers;
    }
    if(args['headers'] is String && args['headers'].isNotEmpty) {
      args['headers'] = JSON.decode(args['headers']);
    }
    if(this.contentType != null) {
      if(!args.containsKey('headers')) {
        args['headers'] = {'content-type' : this.contentType };
      } else {
        if(args['headers'] is Map) {
          args['headers']['content-type'] = this.contentType;
        }
      }
    }
    if(this.handleAs == 'arraybuffer' || this.handleAs == 'blob' || this.handleAs == 'document') {
      args['responseType'] = this.handleAs;
    }
    args['withCredentials'] = this.withCredentials;
    args['callback'] = this._receive;
    args['url'] = this.url;
    args['method'] = this.method;

    return args.containsKey('url') && this._xhr.request(args) != null;
  }
}
