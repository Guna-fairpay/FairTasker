
class AssignedToResponse {
  AssignedToResponse({
      this.status, 
      this.resource,});

  AssignedToResponse.fromJson(dynamic json) {
    status = json['status'];
    // if (json['resource'] != null) {
    //   resource = [];
    //   json['resource'].forEach((v) {
    //     resource!.add(Resource.fromJson(v));
    //   });
    // }
    resource = json['resource'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['resource'] ?? {})]
        : List<Map<String, dynamic>>.from(json['resource'] ?? []);

  }
  int? status;
  List<Map<String,dynamic>>? resource;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   if (resource != null) {
  //     map['resource'] = resource!.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class Resource {
//   Resource({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.departments,
//   this.isMainMenuSelected,
//   this.isSelected,
//   this.shiftTimings,
//
//   });
//
//   Resource.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     departments =  json['departments'] ;
//     isSelected = false;
//
//     shiftTimings=  json['shift_timings'] ;
//     // isSelected = false;
//   }
//   int? id;
//   String? firstName;
//   String? lastName;
//   Map<String, dynamic>? departments;
//   bool? isSelected = false;
//   bool? isMainMenuSelected = false;
//  String? shiftTimings;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['departments'] = departments;
//     map['isSelected'] = isSelected;
//
//      map['shift_timings'] = shiftTimings;
//
//     return map;
//   }
//
// }