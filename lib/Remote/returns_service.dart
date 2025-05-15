import 'package:dio/dio.dart';
import 'package:fairpytasker/data/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:json_annotation/json_annotation.dart';

part 'returns_service.g.dart';

@RestApi()
abstract class ReturnsService {
  factory ReturnsService(Dio dio, {String baseUrl}) = _ReturnsService;

  @GET("vehicle_status/categories")
  Future<BaseResponse> getVehicleCategories();

  @GET("vehicleStatusApi")
  Future<BaseResponse> getVehicleStatus({@Query("vehicle_status") dynamic vehicleStatus, @Query("cohort_id") dynamic cohortId, @Query("branch_code") dynamic branchCode});

  @GET("getCohortsData")
  Future<BaseResponse> getCohorts();

  @POST("expenses")
  @MultiPart()
  Future<BaseResponse> getExpenses({@Body() dynamic body});
}