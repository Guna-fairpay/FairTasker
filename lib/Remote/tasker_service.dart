import 'package:dio/dio.dart';
import 'package:fairpytasker/data/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasker_service.g.dart';

@RestApi()
abstract class TaskerService {
  factory TaskerService(Dio dio, {String baseUrl}) = _TaskerService;

  @POST("login")
  @FormUrlEncoded()
  Future<BaseResponse> login(
      @Field("email") String email, @Field("password") String password,
      {@Field("remember") bool remember = true});

  @POST("logout")
  Future<BaseResponse> logout();

  @GET("getBearerToken")
  Future<BaseResponse> getBearerToken();

  @GET("getBranch")
  Future<BaseResponse> getBranch();

  @GET("checkinout-master")
  Future<BaseResponse> getCheckInCheckOutMaster();

  @GET("settings")
  Future<BaseResponse> getSettings();

  @GET("user-list")
  Future<BaseResponse> getUserList();

  @GET("getresources")
  Future<BaseResponse> getResources();

  @GET("group-person")
  Future<BaseResponse> getGroupPerson();

  @GET("taskCategoryGroup")
  Future<BaseResponse> getTaskCategoryGroup();

  @GET("getMaintanceCheckList")
  Future<BaseResponse> getMaintenanceCheckList();

  @GET("todo")
  Future<BaseResponse> getToDos();

  @GET("group-vehicle")
  Future<BaseResponse> getGroupVehicle();

  @POST("save-bouncie-vehicle")
  Future<BaseResponse> saveBouncieVehicle();

  @GET("todo-data")
  Future<BaseResponse> toDoData(
      {@Query("resource") String? resource,
      @Query("date") String? date,
      @Query("status") String? status,
      @Query("branch_id") int? branchId});

  @GET("getCompletedTodo")
  Future<BaseResponse> completedTodo({@Query("from") String? from, @Query("to") String? to, @Query("branch_id") int? branchId});
}
