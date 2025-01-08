class ChatMessageResponse {
  ChatMessageResponse({
      this.status, 
      this.chats, 
      this.total,});

  ChatMessageResponse.fromJson(dynamic json) {

    chats = json['chats'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['chats'] ?? {})]
        : List<Map<String, dynamic>>.from(json['chats'] ?? []);
    total = json['total'];
    status = json['status'];

    // status = json['status'];
    // if (json['chats'] != null) {
    //   chats = [];
    //   json['chats'].forEach((v) {
    //     chats?.add(Chats.fromJson(v));
    //   });
    // }
    // total = json['total'];
  }
  int? status;
  List<Map<String,dynamic>>? chats;
  int? total;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   if (chats != null) {
  //     map['chats'] = chats?.map((v) => v.toJson()).toList();
  //   }
  //   map['total'] = total;
  //   return map;
  // }

}

// class Chats {
//   Chats({
//       this.id,
//       this.sender,
//       this.receiver,
//       this.message,
//       this.roomId,
//       this.readAt,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   Chats.fromJson(dynamic json) {
//     id = json['id'];
//     sender = json['sender'];
//     receiver = json['receiver'];
//     message = json['message'];
//     roomId = json['room_id'];
//     readAt = json['read_at'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? sender;
//   String? receiver;
//   String? message;
//   dynamic roomId;
//   dynamic readAt;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['sender'] = sender;
//     map['receiver'] = receiver;
//     map['message'] = message;
//     map['room_id'] = roomId;
//     map['read_at'] = readAt;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }