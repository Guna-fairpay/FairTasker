

class WorkingGetConfigurationResponse{
  WorkingGetConfigurationResponse({
    this.data,
});
  WorkingGetConfigurationResponse.fromJson(dynamic json)
  {
    data = json['data']is Map<String, dynamic>? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String, dynamic>>? data;
}