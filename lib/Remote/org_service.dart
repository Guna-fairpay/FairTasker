import 'package:dio/dio.dart';
import 'package:fairpytasker/data/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:json_annotation/json_annotation.dart';

part 'org_service.g.dart';

@RestApi()
abstract class OrgService {
  factory OrgService(Dio dio, {String baseUrl}) = _OrgService;

  @GET("getWorkingHourByUser/{hrmId}")
  Future<BaseResponse> getWorkingHoursByUser(@Path("hrmId") dynamic hrmId);

  @GET("userPunchList")
  Future<BaseResponse> getPunchList();

  @GET("employeeList")
  Future<BaseResponse> getEmployeeList();

  @POST("saveWorkingHour")
  Future<BaseResponse> saveWorkingHours(@Body() Map<String, dynamic> body);

  @PUT("updateWorkingHour/{id}")
  Future<BaseResponse> updateWorkingHours(@Path("id") dynamic id,@Body() Map<String, dynamic> body);

  @GET("employeeWorkHours")
  Future<BaseResponse> getEmployeeWorkHours(@Query("startDate") String? startDate, @Query("endDate") String? endDate);

  @GET("getWorkingHours")
  Future<BaseResponse> getWorkingHours();

  @POST("employeeAdd")
  Future<BaseResponse> addEmployee(@Body() Map<String, dynamic> body);

  @GET("leaveList")
  Future<BaseResponse> getLeaveList();

  @GET("leaveTypeList")
  Future<BaseResponse> getLeaveTypeList();

  @POST("addLeave/{id}")
  Future<BaseResponse> addLeave(@Path("id") dynamic hrmId, @Body() Map<String, dynamic> body);

  @POST("updateLeave/{id}")
  Future<BaseResponse> updateLeave(@Path("id") dynamic hrmId, @Body() Map<String, dynamic> body);

  @POST("leaveApprove/{id}")
  Future<BaseResponse> leaveApprove(@Body() Map<String, dynamic> body);


}