class TaskDetailResponse {
  TaskDetailResponse({
    this.status,
    this.todo,
  });

  TaskDetailResponse.fromJson(dynamic json) {
    status = json['status'];
    todo = json['todo'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['todo'] ?? {})]
        : List<Map<String, dynamic>>.from(json['todo'] ?? []);
  }
  int? status;
  List<Map<String, dynamic>>? todo;
}

/*
class Todo {
  Todo({
      this.id, 
      this.userId, 
      this.userGroupId, 
      this.title, 
      this.todoDate, 
      this.todoTime, 
      this.location, 
      this.locationId, 
      this.address, 
      this.vendorId, 
      this.vendorName, 
      this.priority, 
      this.reminder, 
      this.status, 
      this.recurringId, 
      this.recurring, 
      this.referenceId, 
      this.reservationName, 
      this.cohortId, 
      this.cohortName, 
      this.vin, 
      this.vehicleName, 
      this.vehicleImage, 
      this.vehicleStatusId, 
      this.vehicleStatusCategory, 
      this.vehicleStatusChecklist, 
      this.person, 
      this.personId, 
      this.expenseAttachment, 
      this.expenseAmount, 
      this.expenseDescription, 
      this.categoryId, 
      this.categoryName, 
      this.subcategoryId, 
      this.subcategoryName, 
      this.expenseId, 
      this.expenseTo, 
      this.notes, 
      this.reason, 
      this.images, 
      this.vehicleGroupId, 
      this.tripDriven, 
      this.furtherTaskId, 
      this.furtherTaskName, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.completedAt, 
      this.parts, 
      this.supplies, 
      this.users, 
      this.reasonImages, 
      this.vehicles,});

  Todo.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    userGroupId = json['user_group_id'];
    title = json['title'];
    todoDate = json['todo_date'];
    todoTime = json['todo_time'];
    location = json['location'];
    locationId = json['location_id'];
    address = json['address'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    priority = json['priority'];
    reminder = json['reminder'];
    status = json['status'];
    recurringId = json['recurring_id'];
    recurring = json['recurring'];
    referenceId = json['reference_id'];
    reservationName = json['reservation_name'];
    cohortId = json['cohort_id'];
    cohortName = json['cohort_name'];
    vin = json['vin'];
    vehicleName = json['vehicle_name'];
    vehicleImage = json['vehicle_image'];
    vehicleStatusId = json['vehicle_status_id'];
    vehicleStatusCategory = json['vehicle_status_category'];
    vehicleStatusChecklist = json['vehicle_status_checklist'];
    person = json['person'];
    personId = json['person_id'];
    expenseAttachment = json['expense_attachment'];
    expenseAmount = json['expense_amount'];
    expenseDescription = json['expense_description'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subcategoryId = json['subcategory_id'];
    subcategoryName = json['subcategory_name'];
    expenseId = json['expense_id'];
    expenseTo = json['expense_to'];
    notes = json['notes'];
    reason = json['reason'];
    images = json['images'];
    vehicleGroupId = json['vehicle_group_id'];
    tripDriven = json['trip_driven'];
    furtherTaskId = json['further_task_id'];
    furtherTaskName = json['further_task_name'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    completedAt = json['completed_at'];
    if (json['parts'] != null) {
      parts = [];
      json['parts'].forEach((v) {
        parts?.add(Dynamic.fromJson(v));
      });
    }
    if (json['supplies'] != null) {
      supplies = [];
      json['supplies'].forEach((v) {
        supplies?.add(Dynamic.fromJson(v));
      });
    }
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    if (json['reason_images'] != null) {
      reasonImages = [];
      json['reason_images'].forEach((v) {
        reasonImages?.add(Dynamic.fromJson(v));
      });
    }
    if (json['vehicles'] != null) {
      vehicles = [];
      json['vehicles'].forEach((v) {
        vehicles?.add(Dynamic.fromJson(v));
      });
    }
  }
  int? id;
  String? userId;
  dynamic userGroupId;
  String? title;
  String? todoDate;
  String? todoTime;
  dynamic location;
  dynamic locationId;
  dynamic address;
  dynamic vendorId;
  dynamic vendorName;
  dynamic priority;
  dynamic reminder;
  String? status;
  dynamic recurringId;
  dynamic recurring;
  dynamic referenceId;
  dynamic reservationName;
  String? cohortId;
  dynamic cohortName;
  String? vin;
  String? vehicleName;
  dynamic vehicleImage;
  int? vehicleStatusId;
  int? vehicleStatusCategory;
  int? vehicleStatusChecklist;
  dynamic person;
  dynamic personId;
  dynamic expenseAttachment;
  dynamic expenseAmount;
  dynamic expenseDescription;
  dynamic categoryId;
  dynamic categoryName;
  dynamic subcategoryId;
  dynamic subcategoryName;
  dynamic expenseId;
  dynamic expenseTo;
  dynamic notes;
  dynamic reason;
  dynamic images;
  dynamic vehicleGroupId;
  dynamic tripDriven;
  dynamic furtherTaskId;
  dynamic furtherTaskName;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic completedAt;
  List<dynamic>? parts;
  List<dynamic>? supplies;
  Users? users;
  List<dynamic>? reasonImages;
  List<dynamic>? vehicles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['user_group_id'] = userGroupId;
    map['title'] = title;
    map['todo_date'] = todoDate;
    map['todo_time'] = todoTime;
    map['location'] = location;
    map['location_id'] = locationId;
    map['address'] = address;
    map['vendor_id'] = vendorId;
    map['vendor_name'] = vendorName;
    map['priority'] = priority;
    map['reminder'] = reminder;
    map['status'] = status;
    map['recurring_id'] = recurringId;
    map['recurring'] = recurring;
    map['reference_id'] = referenceId;
    map['reservation_name'] = reservationName;
    map['cohort_id'] = cohortId;
    map['cohort_name'] = cohortName;
    map['vin'] = vin;
    map['vehicle_name'] = vehicleName;
    map['vehicle_image'] = vehicleImage;
    map['vehicle_status_id'] = vehicleStatusId;
    map['vehicle_status_category'] = vehicleStatusCategory;
    map['vehicle_status_checklist'] = vehicleStatusChecklist;
    map['person'] = person;
    map['person_id'] = personId;
    map['expense_attachment'] = expenseAttachment;
    map['expense_amount'] = expenseAmount;
    map['expense_description'] = expenseDescription;
    map['category_id'] = categoryId;
    map['category_name'] = categoryName;
    map['subcategory_id'] = subcategoryId;
    map['subcategory_name'] = subcategoryName;
    map['expense_id'] = expenseId;
    map['expense_to'] = expenseTo;
    map['notes'] = notes;
    map['reason'] = reason;
    map['images'] = images;
    map['vehicle_group_id'] = vehicleGroupId;
    map['trip_driven'] = tripDriven;
    map['further_task_id'] = furtherTaskId;
    map['further_task_name'] = furtherTaskName;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['completed_at'] = completedAt;
    if (parts != null) {
      map['parts'] = parts?.map((v) => v.toJson()).toList();
    }
    if (supplies != null) {
      map['supplies'] = supplies?.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      map['users'] = users?.toJson();
    }
    if (reasonImages != null) {
      map['reason_images'] = reasonImages?.map((v) => v.toJson()).toList();
    }
    if (vehicles != null) {
      map['vehicles'] = vehicles?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Users {
  Users({
      this.id, 
      this.hrmId, 
      this.firstName, 
      this.lastName, 
      this.phone, 
      this.email, 
      this.emailVerifiedAt, 
      this.department, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.departments,});

  Users.fromJson(dynamic json) {
    id = json['id'];
    hrmId = json['hrm_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    department = json['department'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    departments = json['departments'] != null ? Departments.fromJson(json['departments']) : null;
  }
  int? id;
  int? hrmId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  dynamic emailVerifiedAt;
  String? department;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Departments? departments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['hrm_id'] = hrmId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['phone'] = phone;
    map['email'] = email;
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
  int? id;
  String? name;
  String? head;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['head'] = head;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}*/
