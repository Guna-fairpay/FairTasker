

class WorkingReasonResponse {
  WorkingReasonResponse({
    this.comments,
});

 WorkingReasonResponse.fromJson(dynamic json){
  comments = json['comments'] is Map<String, dynamic>
? [Map<String, dynamic>.from(json['comments'] ?? {})]
    : List<Map<String, dynamic>>.from(json['comments'] ?? []);
}
List<Map<String, dynamic>>? comments;
}