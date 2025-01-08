class VendorResponse {
  VendorResponse({
    this.data,
    this.status,
    this.message,
  });

  VendorResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

  /*Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }*/
}


/*
class VendorData {
  VendorData({
      this.id,
      this.name,
      this.vendorType,
      this.vendor_typeId,
      this.address,
      this.phone,
      this.paymentMethodId,
      this.expertise,
      this.description,
      this.images,
      this.status,
      this.platform,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.paymentMethod,
      });

  VendorData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    vendor_typeId = json['type_id'];
    address = json['address'];
    phone = json['phone'];
    paymentMethodId = json['payment_method_id'];
    expertise = json['expertise'];
    description = json['description'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(VendorImages.fromJson(v));
      });
    }
    status = json['status'];
    platform = json['platform'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentMethod = json['payment_method'] != null ? PaymentMethod.fromJson(json['payment_method']) : null;
    vendorType = json['vendor_type'] != null ? VendorType.fromJson(json['vendor_type']) : null;
  }
  int? id;
  String? name;
  int? vendor_typeId;
  String? address;
  String? phone;
  int? paymentMethodId;
  String? expertise;
  String? description;
  List<VendorImages>? images;
  int? status;
  dynamic platform;
  dynamic deletedAt;
  dynamic createdAt;
  String? updatedAt;
  PaymentMethod? paymentMethod;
  VendorType? vendorType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['type_id'] = vendor_typeId;
    map['address'] = address;
    map['phone'] = phone;
    map['payment_method_id'] = paymentMethodId;
    map['expertise'] = expertise;
    map['description'] = description;
    map['status'] = status;
    map['platform'] = platform;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (paymentMethod != null) {
      map['payment_method'] = paymentMethod?.toJson();
    }
    if (vendorType != null) {
      map['vendor_type'] = vendorType?.toJson();
    }
    return map;
  }

}

/// "id": 4,
/// "vendor_id": 188,
/// "name": "WhatsApp Image 2024-08-28 at 11.31.07_4fcb2544.jpg",
/// "path": "vendors/188/66dc4e088c55e.jpg",
/// "file_type": "jpg",
/// "image_type": "original",
/// "image_size": "399.12 KB",
/// "deleted_at": null,
/// "created_at": "2024-09-07T12:58:48.000000Z",
/// "updated_at": "2024-09-07T12:58:48.000000Z"
class VendorImages {
  VendorImages({
    this.id,
    this.vendorId,
    this.name,
    this.path,
    this.fileType,
    this.imageType,
    this.imageSize,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,});

  VendorImages.fromJson(dynamic json) {
    id = json['id'];
    vendorId=json['vendor_id'];
    name = json['name'];
    path = json['path'];
    imageType = json['image_type'];
    imageSize = json['image_size'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  dynamic id;
  int?vendorId;
  String? name;
  String? path;
  File? fileType;
  dynamic imageType;
  dynamic imageSize;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vendor_id']=vendorId;
    map['name'] = name;
    map['path'] = path;
    map['file_type'] = fileType;
    map['image_type'] = imageType;
    map['image_size'] = imageSize;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.name,
    this.status,
    this.platform,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,});

  PaymentMethod.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    platform = json['platform'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  int? status;
  dynamic platform;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    map['platform'] = platform;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}
*/

