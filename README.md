<img src="http://bwu-dart.github.io/core_elements/assets/polymer/p-logo.svg" alt="Polymer logo" width="120px" />

# Core elements for Polymer.dart

A port of polymer.js' [core-elements](http://polymer.github.io/core-docs/) to Polymer.dart. 
The intent of the authors is to contribute the work to the Dart project itself (https://www.dartlang.org).

### Dart ports of Polymer elements from [PolymerLabs](http://www.polymer-project.org/docs/elements/polymer-elements.html) can be found at 
* [polymer_elements](https://github.com/bwu-dart/polymer_elements)
* [polymer_ui_elements](https://github.com/bwu-dart/polymer_ui_elements)


## Documentation
* The Dart source files of an element often contain some documentation (Dartdoc) how to use the element. You can also find this documentation online at  
* [DartDoc](http://bwu-dart.github.io/core_elements/dartdoc)
* Almost each element has an associated demo page which shows how to use the element. 
Open the 'demo' links below to take a look.
The source code of these demo pages can be found in the [example subdirectory of the package](https://github.com/bwu-dart/core_elements/tree/master/example). 
The actual implementation of the demo page is often outsourced to files in the `example/src/element_name` subdirectory.


## Usage
* add the following to your pubspec.yaml file: 

```yaml
dependencies:
  core_elements:
```
For more details take a look at the demo pages. 

## Feedback

Your feedback is very much appreciated. We are excited to hear about your experience using polymer_elements.
We need your feedback to continually improve the qualtiy.

- Just [Create a New Issue](https://github.com/bwu-dart/core_elements/issues/new)

- Please let us know which components we should prioritize. [Just add a comment to #3](../../issues/3)


## General notes

* Tested with Dart SDK version 1.4.0-dev.6.7

### Status

Element name                    |   Status         | Comment      | Demo
------------------------------- | ---------------- | ------------ | ----
polymer-ajax                    | ported           |              | [demo](http://bwu-dart.github.io/core_elements/example/core_ajax.html)
polymer-collapse                | ported           |              | [demo](http://bwu-dart.github.io/core_elements/example/core_collapse.html)
polymer-tooltip                 | ported           |              | [demo](http://bwu-dart.github.io/core_elements/example/core_tooltip.html)


### License
BSD 3-clause license (see [LICENSE](https://github.com/bwu-dart/core_elements/blob/master/LICENSE) file).

[![Build Status](https://drone.io/github.com/bwu-dart/core_elements/status.png)](https://drone.io/github.com/bwu-dart/core_elements/latest)
