import 'dart:convert';

import 'package:code_factory_app/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }
  static List<String> listPathsToUrl(List value){
    return value.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    return stringToBase64.encode(plain);
  }

  static DateTime stringToDateTime(String value){
    return DateTime.parse(value);
  }
}

