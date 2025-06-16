import 'dart:convert';

import 'package:fairpytasker/core/app/helper/converter.dart';
import 'package:http/http.dart';

extension ResponseExtension on Response? {

  List<int> get _successCodes => [200,201,202];

  bool get isSuccess => (this != null) && _successCodes.contains(this?.statusCode);

  Future<Map<String, dynamic>?> get mapData async {
    if (!isSuccess) throw Exception("${this?.statusCode}: ${jsonDecode(this?.body ?? "")?['message'] ?? jsonDecode(this?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
    return ((this == null) || (this?.body.isEmpty ?? false)) ? null : await parseString<Map<String, dynamic>>(this!.body, (json) => Map<String, dynamic>.from(json));
  }

  Future<List<Map<String, dynamic>>?> get mapListData async {
    if (!isSuccess) throw Exception("${this?.statusCode}: ${jsonDecode(this?.body ?? "")?['message'] ?? jsonDecode(this?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
    return ((this == null) || (this?.body.isEmpty ?? false)) ? null : await parseString<List<Map<String, dynamic>>>(this!.body, (json) => List<Map<String, dynamic>>.from(json));
  }

}