
class PartsResponse {
  PartsResponse({
      this.data,
      this.status,
      this.message,
  });

  PartsResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
     message = json['message'] ?? "";
     status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;


/*  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }*/

}

// class PartsData {
//   PartsData({
//       this.id,
//       this.deleteId,
//       this.name,
//       this.vendorId,
//       this.note,
//       this.status,
//       this.platform,
//       this.isSelected,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   PartsData.fromJson(dynamic json) {
//     id = json['id'];
//     deleteId = 0;
//     name = json['name'];
//     vendorId = json['vendor_id'];
//     note = json['note'];
//     status = json['status'];
//     platform = json['platform'];
//     isSelected = false;
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   int? deleteId;
//   String? name;
//   dynamic vendorId;
//   dynamic note;
//   int? status;
//   String? platform;
//   bool? isSelected = false;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   List<Map<String, dynamic>> toJsonList(List<PartsData> list) {
//     final List<Map<String, dynamic>> mapList = [];
//     for(int i=0; i<list.length; i++) {
//       final map = <String, dynamic>{};
//       map['parts_id'] = list[i].id;
//       map['parts_name'] = list[i].name;
//       mapList.add(map);
//   }
//     return mapList;
//   }
//
// }