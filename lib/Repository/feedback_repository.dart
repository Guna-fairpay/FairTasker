import 'package:fairpytasker/Response/feedback_status_response.dart';
import 'package:fairpytasker/Response/feedback_view_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/helper/converter.dart';
import 'package:fairpytasker/data/api_client.dart';

class FeedBackRepository {
  final ApiClient _apiClient = ApiClient();

  String get _viewApiUrl => "${Str.BASE_URL}feedback";
  String get _feedbackStatusApiUrl => "${Str.BASE_URL}feedback-status";

  Future<FeedbackViewResponse?> fetchFeedback() async {
    var response = await _apiClient.callGetMethod(_viewApiUrl);
    if (response.isSuccess) {
      return await parseString<FeedbackViewResponse>(response!.body, (json) => FeedbackViewResponse.fromJson(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<FeedbackStatusResponse?> fetchFeedbackStatus() async {
    var response = await _apiClient.callGetMethod(_feedbackStatusApiUrl);
    if (response.isSuccess) {
      return await parseString<FeedbackStatusResponse>(response!.body, (json) => FeedbackStatusResponse.fromJson(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> deleteFeedback(dynamic id) async {
    var response = await _apiClient.callDelete("$_viewApiUrl/$id");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

}