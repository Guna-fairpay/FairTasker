
class TaskCategoryGroupResponse {
  TaskCategoryGroupResponse({
    this.data
});

  TaskCategoryGroupResponse.fromJson(dynamic json)
{
data = json['data']is Map<String, dynamic>? [Map<String, dynamic>.from(json['data'] ?? {})]
    : List<Map<String, dynamic>>.from(json['data'] ?? []);
}
List<Map<String, dynamic>>? data;

}

class CohortsDataResponse{
  CohortsDataResponse({
    this.data
  });

  CohortsDataResponse.fromJson(dynamic json)
  {
    data = json['cohortsData']is Map<String, dynamic>? [Map<String, dynamic>.from(json['cohortsData'] ?? {})]
        : List<Map<String, dynamic>>.from(json['cohortsData'] ?? []);
  }
  List<Map<String, dynamic>>? data;

}