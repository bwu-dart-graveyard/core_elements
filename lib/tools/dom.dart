library core_elements.tools;

int parseInt(String s) {
  if(s == null || s.trim() == '') {
    return 0;
  }
  if(s.endsWith('%')) {
    return int.parse(s.substring(0, s.length-1));
  } else if (s.endsWith('px')) {
    return int.parse(s.substring(0, s.length-2));
  }
  try {
    return int.parse(s);
  } on FormatException catch (e) {
    print('message: ${e.message}; value: "${s}"');
    rethrow;
  }
}

double parseDouble(String s) {
  if(s == null || s.trim() == '') {
    return 0.0;
  }
  if(s.endsWith('%')) {
    return double.parse(s.substring(0, s.length-1));
  } else if (s.endsWith('px')) {
    return double.parse(s.substring(0, s.length-2));
  }
  try {
    return double.parse(s);
  } on FormatException catch (e) {
    print('message: ${e.message}; value: "${s}"');
    rethrow;
  }
}