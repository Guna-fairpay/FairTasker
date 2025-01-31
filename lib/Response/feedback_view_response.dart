class FeedbackViewResponse {
  FeedbackViewResponse({
      this.status, 
      this.feedback,});

  FeedbackViewResponse.fromJson(dynamic json) {
    status = json['status'];
    if (json['feedback'] != null) {
      feedback = [];
      json['feedback'].forEach((v) {
        feedback?.add(Feedback.fromJson(v));
      });
    }
  }
  num? status;
  List<Feedback>? feedback;
FeedbackViewResponse copyWith({  num? status,
  List<Feedback>? feedback,
}) => FeedbackViewResponse(  status: status ?? this.status,
  feedback: feedback ?? this.feedback,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (feedback != null) {
      map['feedback'] = feedback?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Feedback {
  Feedback({
      this.id, 
      this.title, 
      this.description, 
      this.priority, 
      this.status, 
      this.feedbackDateTime, 
      this.createdBy, 
      this.updatedBy, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.user, 
      this.attachments,});

  Feedback.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    priority = json['priority'];
    status = json['status'];
    feedbackDateTime = json['feedback_date_time'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(Attachments.fromJson(v));
      });
    }
  }
  num? id;
  String? title;
  String? description;
  String? priority;
  num? status;
  String? feedbackDateTime;
  num? createdBy;
  num? updatedBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  User? user;
  List<Attachments>? attachments;
Feedback copyWith({  num? id,
  String? title,
  String? description,
  String? priority,
  num? status,
  String? feedbackDateTime,
  num? createdBy,
  num? updatedBy,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
  User? user,
  List<Attachments>? attachments,
}) => Feedback(  id: id ?? this.id,
  title: title ?? this.title,
  description: description ?? this.description,
  priority: priority ?? this.priority,
  status: status ?? this.status,
  feedbackDateTime: feedbackDateTime ?? this.feedbackDateTime,
  createdBy: createdBy ?? this.createdBy,
  updatedBy: updatedBy ?? this.updatedBy,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
  user: user ?? this.user,
  attachments: attachments ?? this.attachments,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['status'] = status;
    map['feedback_date_time'] = feedbackDateTime;
    map['created_by'] = createdBy;
    map['updated_by'] = updatedBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (attachments != null) {
      map['attachments'] = attachments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Attachments {
  Attachments({
      this.id, 
      this.feedbackId, 
      this.name, 
      this.path, 
      this.type, 
      this.size, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt,});

  Attachments.fromJson(dynamic json) {
    id = json['id'];
    feedbackId = json['feedback_id'];
    name = json['name'];
    path = json['path'];
    type = json['type'];
    size = json['size'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
  num? id;
  num? feedbackId;
  String? name;
  String? path;
  String? type;
  String? size;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
Attachments copyWith({  num? id,
  num? feedbackId,
  String? name,
  String? path,
  String? type,
  String? size,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
}) => Attachments(  id: id ?? this.id,
  feedbackId: feedbackId ?? this.feedbackId,
  name: name ?? this.name,
  path: path ?? this.path,
  type: type ?? this.type,
  size: size ?? this.size,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['feedback_id'] = feedbackId;
    map['name'] = name;
    map['path'] = path;
    map['type'] = type;
    map['size'] = size;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.hrmId, 
      this.firstName, 
      this.lastName, 
      this.phone, 
      this.email, 
      this.userOrder, 
      this.branchId, 
      this.fromTime, 
      this.toTime, 
      this.fromTime2, 
      this.toTime2, 
      this.unavailableDays, 
      this.shiftTimings, 
      this.emailVerifiedAt, 
      this.department, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.departments,});

  User.fromJson(dynamic json) {
    id = json['id'];
    hrmId = json['hrm_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    userOrder = json['user_order'];
    branchId = json['branch_id'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    fromTime2 = json['from_time2'];
    toTime2 = json['to_time2'];
    unavailableDays = json['unavailable_days'];
    shiftTimings = json['shift_timings'];
    emailVerifiedAt = json['email_verified_at'];
    department = json['department'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    departments = json['departments'] != null ? Departments.fromJson(json['departments']) : null;
  }
  num? id;
  num? hrmId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  num? userOrder;
  num? branchId;
  dynamic fromTime;
  dynamic toTime;
  dynamic fromTime2;
  dynamic toTime2;
  dynamic unavailableDays;
  dynamic shiftTimings;
  dynamic emailVerifiedAt;
  String? department;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Departments? departments;
User copyWith({  num? id,
  num? hrmId,
  String? firstName,
  String? lastName,
  String? phone,
  String? email,
  num? userOrder,
  num? branchId,
  dynamic fromTime,
  dynamic toTime,
  dynamic fromTime2,
  dynamic toTime2,
  dynamic unavailableDays,
  dynamic shiftTimings,
  dynamic emailVerifiedAt,
  String? department,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
  Departments? departments,
}) => User(  id: id ?? this.id,
  hrmId: hrmId ?? this.hrmId,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  phone: phone ?? this.phone,
  email: email ?? this.email,
  userOrder: userOrder ?? this.userOrder,
  branchId: branchId ?? this.branchId,
  fromTime: fromTime ?? this.fromTime,
  toTime: toTime ?? this.toTime,
  fromTime2: fromTime2 ?? this.fromTime2,
  toTime2: toTime2 ?? this.toTime2,
  unavailableDays: unavailableDays ?? this.unavailableDays,
  shiftTimings: shiftTimings ?? this.shiftTimings,
  emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
  department: department ?? this.department,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  departments: departments ?? this.departments,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['hrm_id'] = hrmId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['phone'] = phone;
    map['email'] = email;
    map['user_order'] = userOrder;
    map['branch_id'] = branchId;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['from_time2'] = fromTime2;
    map['to_time2'] = toTime2;
    map['unavailable_days'] = unavailableDays;
    map['shift_timings'] = shiftTimings;
    map['email_verified_at'] = emailVerifiedAt;
    map['department'] = department;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (departments != null) {
      map['departments'] = departments?.toJson();
    }
    return map;
  }

}

class Departments {
  Departments({
      this.id, 
      this.name, 
      this.head, 
      this.createdAt, 
      this.updatedAt,});

  Departments.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    head = json['head'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  String? head;
  String? createdAt;
  String? updatedAt;
Departments copyWith({  num? id,
  String? name,
  String? head,
  String? createdAt,
  String? updatedAt,
}) => Departments(  id: id ?? this.id,
  name: name ?? this.name,
  head: head ?? this.head,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['head'] = head;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}