
class SuppliesResponse {
  SuppliesResponse({
    this.data,
    this.status,
    this.message,
  });

  SuppliesResponse.fromJson(dynamic json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }
  List<Map<String,dynamic>>? data;
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

/*
class SuppliesData {
  SuppliesData({
      this.id,
      this.deleteId,
      this.name,
      this.description,
      this.status,
      this.platform,
      this.isSelected,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,});

  SuppliesData.fromJson(dynamic json) {
    id = json['id'];
    deleteId = 0;
    name = json['name'];
    description = json['description'];
    status = json['status'];
    isSelected = false;
    platform = json['platform'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? deleteId;
  String? name;
  String? description;
  int? status;
  String? platform;
  bool? isSelected = false;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  List<Map<String, dynamic>> toJsonList(List<SuppliesData> list) {
    final List<Map<String, dynamic>> mapList = [];
    for(int i=0; i<list.length; i++) {
      final map = <String, dynamic>{};
      map['supplies_id'] = list[i].id;
      map['supplies_name'] = list[i].name;
      mapList.add(map);
    }
    return mapList;
  }


}*/
