import 'package:fairpytasker/core/app/helper/converter.dart';
import 'package:http/http.dart';

extension ResponseExtension on Response? {

  List<int> get _successCodes => [200, 202];

  bool get isSuccess => (this != null) && _successCodes.contains(this?.statusCode);

  Future<Map<String, dynamic>> get mapData async {
    return (this == null) ? {} : await parseString<Map<String, dynamic>>(this!.body, (json) => Map<String, dynamic>.from(json));
  }

}