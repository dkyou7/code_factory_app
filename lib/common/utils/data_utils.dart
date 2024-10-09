import 'package:code_factory_app/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }
  static List<String> listPathsToUrl(List value){
    return value.map((e) => pathToUrl(e)).toList();
  }
}

