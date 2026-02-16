// ignore_for_file: camel_case_types

class Blob {
  Blob(List<dynamic> blobParts, [String? type]);
}

class Url {
  static String createObjectUrlFromBlob(dynamic blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});
  String? href;
  void setAttribute(String name, String value) {}
  void click() {}
  String? download;
}

class window {
  static void open(String url, String target) {}
}
