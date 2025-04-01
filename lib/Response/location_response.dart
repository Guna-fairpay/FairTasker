
class LocationResponse {
  LocationResponse({
    this.data,
    this.status,
    this.message,});

  LocationResponse.fromJson(dynamic json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
    // if (json['data'] != null) {
    //   data = [];
    //   json['data'].forEach((v) {
    //     data?.add(LocationData.fromJson(v));
    //   });
    // }
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

/*
class LocationData {
  LocationData({
      this.id, 
      this.name, 
      this.parentId, 
      this.status, 
      this.platform, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.addresses,
      this.isSelected,
  });

  LocationData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    status = json['status'];
    platform = json['platform'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses?.add(Addresses.fromJson(v));
      });
    }
    isSelected = false;
  }
  int? id;
  String? name;
  dynamic parentId;
  int? status;
  dynamic platform;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;
  List<Addresses>? addresses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['parent_id'] = parentId;
    map['status'] = status;
    map['platform'] = platform;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
*/
/*    if (addresses != null) {
      map['addresses'] = addresses?.map((v) => v.toJson()).toList();
    }*//*

    return map;
  }

}

class Addresses {
  Addresses({
      this.id,
      this.locationId,
      this.deleteId,
      this.address,
      this.status,
      this.platform,
      this.isSelected,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,});

  Addresses.fromJson(dynamic json) {
    id = json['id'];
    locationId = json['location_id'];
    address = json['address'];
    status = json['status'];
    platform = json['platform'];
    isSelected = false;
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? locationId;
  int? deleteId;
  String? address;
  int? status;
  String? platform;
  bool? isSelected;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson(List<String> list, String name) {
    final map = <String, dynamic>{};
    // map['address'] = (list).map((e) => e.toString()).toList();
    // map['address'] = list; // Updated this line
    // map['address'] = list.map((e) => e.toString()).toList(); // Updated this line
    map['address'] = list.map((e) => '"$e"').toList(); // Updated this line
    map['name'] = name;
    map['platform'] = "TaskerApp";
    map['status'] = "1";
    return map;
  }

}*/
