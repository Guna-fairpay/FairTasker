import 'package:dio/dio.dart';
import 'package:fairpytasker/data/base_response.dart';
import 'package:retrofit/retrofit.dart';

part 'returns_service.g.dart';

@RestApi()
abstract class ReturnsService {
  factory ReturnsService(Dio dio, {String baseUrl}) = _ReturnsService;

  @GET("vehicle_status/categories")
  Future<BaseResponse> getVehicleCategories();

  @GET("vehicleStatusApi")
  Future<BaseResponse> getVehicleStatus({@Query("vehicle_status") String? vehicleStatus, @Query("cohort_id") int? cohortId, @Query("branch_code") String? branchCode});

  @GET("getCohortsData")
  Future<BaseResponse> getCohorts();

  @POST("expenses")
  @MultiPart()
  Future<BaseResponse> uploadExpenses(@Body() Map<String, dynamic> body);

  @POST("expenses_update/{id}")
  @MultiPart()
  Future<BaseResponse> updateExpenses(@Path("id") dynamic id, @Body() Map<String, dynamic> body);
}