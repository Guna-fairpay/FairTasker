class FeedbackStatusResponse {
  FeedbackStatusResponse({
      this.status, 
      this.statusList,});

  FeedbackStatusResponse.fromJson(dynamic json) {
    status = json['status'];
    if (json['statusList'] != null) {
      statusList = [];
      json['statusList'].forEach((v) {
        statusList?.add(StatusList.fromJson(v));
      });
    }
  }
  num? status;
  List<StatusList>? statusList;
FeedbackStatusResponse copyWith({  num? status,
  List<StatusList>? statusList,
}) => FeedbackStatusResponse(  status: status ?? this.status,
  statusList: statusList ?? this.statusList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (statusList != null) {
      map['statusList'] = statusList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class StatusList {
  StatusList({
      this.id, 
      this.name, 
      this.active, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  StatusList.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  num? active;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
StatusList copyWith({  num? id,
  String? name,
  num? active,
  dynamic deletedAt,
  dynamic createdAt,
  dynamic updatedAt,
}) => StatusList(  id: id ?? this.id,
  name: name ?? this.name,
  active: active ?? this.active,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['active'] = active;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}