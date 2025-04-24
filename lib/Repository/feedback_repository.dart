import 'dart:io';

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
  String get _updateFeedBackApiUrl => "${Str.BASE_URL}update-feedback";
  String get _feedbackComments => "${Str.BASE_URL}get-feedback-comments";
  String get _addFeedbackComments => "${Str.BASE_URL}add-feedback-comment";
  String get _deleteFeedbackComment => "${Str.BASE_URL}delete-feedback-comment";
  String get _updateFeedbackComment => "${Str.BASE_URL}update-feedback-comment/";
  String get _deleteCommentAttachment => "${Str.BASE_URL}delete-comment-attachment/";

  Future<FeedbackViewResponse?> fetchFeedback() async {
    var response = await _apiClient.callGetMethod(_viewApiUrl);
    if (response.isSuccess) {
      return await parseString<FeedbackViewResponse>(response!.body, (json) => FeedbackViewResponse.fromJson(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> updateFeedback(dynamic feedBackId, {dynamic title, dynamic description, dynamic priority, dynamic status, int lastImageIndex = 0, int lastVideoIndex = 0,List<File>? files}) async {
    var fields = {
      "title" : title.toString(),
      "description" : description.toString(),
      "status" : status.toString(),
      "priority" : priority.toString()
    };
    var filePaths = files?.map((e) => e.path).toList() ?? [];
    var response = await _apiClient.callPostMethodWithBody("$_addFeedbackComments/$feedBackId", body: fields, files: filePaths, fieldName: null, lastImageIndex: lastImageIndex, lastVideoIndex: lastVideoIndex);
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
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

  Future<Map<String, dynamic>?> getFeedback(dynamic feedBackId) async {
    var response = await _apiClient.callGetMethod("$_viewApiUrl/$feedBackId");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> getFeedBackComments(dynamic feedBackId) async {
    var response = await _apiClient.callGetMethod("$_feedbackComments/$feedBackId");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> addFeedBackComments(dynamic feedBackId,
      { dynamic comment, List<File>? files}) async {
    var fields = {"comment" : comment.toString()};
    var filePaths = files?.map((e) => e.path).toList() ?? [];
    var response = await _apiClient.callPostMethodWithBody("$_addFeedbackComments/$feedBackId", body: fields, files: filePaths, autoIncrement: true, fieldName: "attachments");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> deleteFeedbackComment(dynamic commentId) async {
    var response = await _apiClient.callDelete("$_deleteFeedbackComment/$commentId");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?> updateFeedbackComment(dynamic commentId, {dynamic comment, List<File>? files}) async {
    var fields = {"comment" : comment.toString()};
    var filePaths = files?.map((e) => e.path).toList() ?? [];
    var response = await _apiClient.callPostMethodWithBody("$_updateFeedbackComment$commentId", body: fields, files: filePaths, autoIncrement: true, fieldName: "attachments");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
    } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>?>deleteCommentAttachment(dynamic attachmentId) async {
    var response = await _apiClient.callDelete("$_deleteCommentAttachment$attachmentId");
    if (response.isSuccess) {
      return await parseString<Map<String, dynamic>>(response!.body, (json) => Map<String, dynamic>.from(json));
      } else {
      throw Exception("${response?.statusCode} : ${response?.reasonPhrase}");
    }
  }

}