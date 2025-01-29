import 'package:http/http.dart';

extension ResponseExtension on Response? {

  List<int> get _successCodes => [200, 202];

  bool get isSuccess => (this != null) && _successCodes.contains(this?.statusCode);

}