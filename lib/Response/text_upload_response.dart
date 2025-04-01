
class TaskUploadResponse {
  TaskUploadResponse({
    this.data,});

  TaskUploadResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String,dynamic>>? data;


}

class UploadTextData {
  UploadTextData( {
    this.id,
    this.text,});
  UploadTextData.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
  }
  int? id;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    return map;
  }

}

