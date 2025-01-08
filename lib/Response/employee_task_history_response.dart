class EmployeeTaskHistoryResponse {
  EmployeeTaskHistoryResponse({
      this.status, 
/*      this.history,
      this.taskCount,*/});

  EmployeeTaskHistoryResponse.fromJson(dynamic json) {
    status = json['status'];
    // history = json['history'] != null ? TaskHistory.fromJson(json['history']) : null;
    // taskCount = json['taskCount'] != null ? TaskCount.fromJson(json['taskCount']) : null;
  }
  int? status;
  // TaskHistory? history;
  // TaskCount? taskCount;

  /*Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (history != null) {
      map['history'] = history?.toJson();
    }
    if (taskCount != null) {
      map['taskCount'] = taskCount?.toJson();
    }
    return map;
  }*/

}
