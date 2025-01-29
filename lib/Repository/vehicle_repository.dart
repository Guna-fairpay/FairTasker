
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/Response/vehicle_notes_history_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/Response/create_vehicle_response.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Response/todo_list_response.dart';
import '../Response/vehicle_grouping_response.dart';

class VehicleDataRepo {
  ApiClient apiClient = ApiClient();

  Future<CreateVehicleResponse?> createVehicle(
      CreateVehicleData createVehicleData) async {
    try {
      String apiUrl = '';
      if (createVehicleData.id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vehiclesApi/${createVehicleData.id}";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vehiclesApi";
      }
      Map<String, String> reqMap = {
        "vehicle_id": createVehicleData.vehicleId,
        "vin": createVehicleData.vin,
        "make": createVehicleData.make,
        "model": createVehicleData.model,
        "year": createVehicleData.year,
        "vehicle_number": createVehicleData.vehicleNumber,
        "cohort_id": createVehicleData.selectedCohort.toString(),
        "earnings": createVehicleData.earnings,
        "utilization_rate": createVehicleData.utilizationRate,
        "platform": createVehicleData.platform,
        "mileage": createVehicleData.mileage,
        "wholesale_amount": createVehicleData.wholesaleAmount,
        "vehicle_status": createVehicleData.selectedVehicleStatus.toString(),
        "active": createVehicleData.isActive.toString(),
        "purchase_price": createVehicleData.purchasePrice.toString(),
        "purchase_date": createVehicleData.purchaseDate.toString(),
        "address": createVehicleData.address,
        "bouncie": createVehicleData.bouncie.toString(),
        "air_tag": createVehicleData.airTag.toString(),
        "toll_tags": createVehicleData.tollTag.toString(),
        "spare_tire": createVehicleData.spareTire.toString(),
        "toll_tags_id": createVehicleData.tollTagsId.toString(),
        "tire_size": createVehicleData.tireSize.toString(),
        "spare_key": createVehicleData.spareKey.toString(),
        "permanent_plate": createVehicleData.permanentPlate.toString(),
        "front_license_plate": createVehicleData.frontLicensePlate.toString(),
        "car_number": createVehicleData.carNumber,
        "oil_grade": createVehicleData.oilGrade,
        "front_tire": createVehicleData.frontTire,
        "rear_tire": createVehicleData.rearTire,
        "current_odometer": createVehicleData.currentOdometer,
        "oil_change_odometer": createVehicleData.oilChangeOdometer,
        "maintenance_check": createVehicleData.maintenanceCheck,
        "registration_renewal_date": createVehicleData.regStickerDate.toString(),
        "insurance_agent":createVehicleData.insuranceAgent.toString(),
        "insurance_cost":createVehicleData.insuranceCost.toString(),
        "platform_from": 'TaskerApp'
      };
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());

      request.fields.addAll(reqMap);

      for (int i = 0;
          i < (createVehicleData.chosenPurchaseReceipts.length);
          i++) {
        var file = createVehicleData.chosenPurchaseReceipts[i];

        var multipartFile = http.MultipartFile.fromBytes(
          'files[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Add files to the request
      for (int i = 0; i < (createVehicleData.chosenFiles.length); i++) {
        var file = createVehicleData.chosenFiles[i];

        var multipartFile = http.MultipartFile.fromBytes(
          'images[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      debugPrint('createVehicle.statusCode: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        CreateVehicleResponse createVehicleResponse = CreateVehicleResponse();
        return createVehicleResponse;
      } else {
        // Handle error response
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      debugPrint('createVehicle.exception : ${error.toString()}');
      return null;
    }
  }

/*
  Future<bool?> createVehicle(CreateVehicleData createVehicleData) async {
    try {
      String apiUrl = '';
      if(createVehicleData.id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vehiclesApi/${createVehicleData.id}";
      }else{
        apiUrl = "${Str.LIST_BASE_URL}vehiclesApi";
      }

      String body = jsonEncode({
      "vehicle_id": createVehicleData.vehicleId,
      "vin": createVehicleData.vin,
      "make": createVehicleData.make,
      "model": createVehicleData.model,
      "year": createVehicleData.year,
      "cohort_id": createVehicleData.selectedCohort,
      "earnings": createVehicleData.earnings,
      "utilization_rate": createVehicleData.utilizationRate,
      "platform": createVehicleData.platform,
      "mileage": createVehicleData.mileage,
      "wholesale_amount": createVehicleData.wholesaleAmount,
      "vehicle_status": createVehicleData.selectedSourceType,
      "active": createVehicleData.isActive,
      "platform_from": 'TaskerApp',
      });
      debugPrint("createVendor apiUrl: $apiUrl");
      debugPrint("createVendor body: $body");
      final http.Response? response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint('createVendor api.response.statusCode: ${response.statusCode}');
        debugPrint('createVendor api.response: ${response!.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {

          debugPrint('createVendor api.response.body: ${response.body}');
          debugPrint('createVendor api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createVendor.exception : ${error.toString()}');
      return null;
    }
  }
*/

  Future<bool?> createVehicleGroup(
      String? name, List<String>? list, int? id) async {
    try {
      String body = jsonEncode({"name": name, "vin": list});
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.BASE_URL}group-vehicle/$id";
        response = await apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.BASE_URL}group-vehicle";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }

      debugPrint("createVehicleGroup apiUrl: $apiUrl");
      debugPrint("createVehicleGroup id: $id");
      debugPrint("createVehicleGroup body: $body");
      if (response != null) {
        debugPrint('createVehicleGroup api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createVehicleGroup api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createVehicleGroup.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVehicleImages(int? vehicleId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_images/$vehicleId";
      debugPrint("deleteVehicleImages apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('deleteVehicleImages api.response.body: ${response.body}');
          debugPrint(
              'deleteVehicleImages api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse =
          // GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteVehicleImages.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteExpenseImages(int? expenseId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expense_attachment/$expenseId";
      debugPrint("deleteExpenseImages apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('deleteExpenseImages api.response.body: ${response.body}');
          debugPrint(
              'deleteExpenseImages api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse =
          // GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteExpenseImages.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteExpense(String? expenseId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses/$expenseId";
      debugPrint("deleteExpense apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('deleteExpense api.response.body: ${response.body}');
          debugPrint('deleteExpense api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse =
          // GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteExpense.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVehicle(int? vehicleId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehiclesApi/$vehicleId";

      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteVendor api.response.body: ${response.body}');
          debugPrint('deleteVendor api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVehicleGroup(int? vehicleGroupId) async {
    try {
      String apiUrl = "${Str.BASE_URL}group-vehicle/$vehicleGroupId";
      debugPrint("deleteVehicleGroup apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteVehicleGroup api.response.body: ${response.body}');
          debugPrint(
              'deleteVehicleGroup api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteVehicleGroup.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleHistoryResponse?> getVehicleHistoryList(
    String? pageNo,
    String? vin,
  ) async {
    try {
      String apiUrl = '';
      apiUrl =
          "${Str.BASE_URL}get-vehicle-history?page=$pageNo&vin=$vin&itemPerPage=10";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          //debugPrint('getVehicleHistoryList api.response.body: ${response.body}');
          //debugPrint('getVehicleHistoryList api.statusCode: ${response.statusCode}');

          VehicleHistoryResponse vehicleHistoryResponse =
              VehicleHistoryResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          print(
              'getVehicleHistoryList api.statusCode: $vehicleHistoryResponse');
          return vehicleHistoryResponse;

          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TodoListResponse?> getVehicleHistory(
      String? vin, int? vehicleGroupId) async {
    try {
      String apiUrl = '';
      if (vin != null) {
        apiUrl = "${Str.BASE_URL}get-vehicle-history?vin=$vin";
      } else {
        apiUrl = "${Str.BASE_URL}get-vehicle-history?groupId=$vehicleGroupId";
      }

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('getVehicleHistory api.response.body: ${response.body}');
          debugPrint(
              'getVehicleHistory api.statusCode: ${response.statusCode}');

          TodoListResponse todoListResponse =
              TodoListResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return todoListResponse;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createDepartmentData(String? name, int? head, int? id) async {
    try {
      String body = jsonEncode({
        "name": name,
        "head": head,
        // "platform": "TaskerApp",
      });
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.BASE_URL}updateDepartment/$id";
      } else {
        apiUrl = "${Str.BASE_URL}addDepartment";
      }
      response = await apiClient.callPostMethod(apiUrl, body: body);

      debugPrint("createDepartmentData apiUrl: $apiUrl");
      debugPrint("createDepartmentData body: $body");
      if (response != null) {
        debugPrint('createDepartmentData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createDepartmentData api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createDepartmentData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createCategoryData(String? name, int? id) async {
    try {
      String body = jsonEncode({
        "name": name,
        "platform": "TaskerApp",
        "cohortId": 1,
      });
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}expenses_category/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}expenses_category";
      }
      response = await apiClient.callPostMethod(apiUrl, body: body);

      if (response != null) {
        debugPrint('createCategoryData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createCategoryData api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createCategoryData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createSubCategoryData(
      String? name, String? expenseTo, String? parentId, int? id) async {
    try {
      String body = jsonEncode({
        "name": name,
        "expense_to": expenseTo,
        "parent_id": parentId,
        "platform": "TaskerApp",
      });
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}expenses_category/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}expenses_category";
      }
      response = await apiClient.callPostMethod(apiUrl, body: body);

      debugPrint("createCategoryData apiUrl: $apiUrl");
      debugPrint("createCategoryData body: $body");
      if (response != null) {
        debugPrint('createCategoryData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createCategoryData api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createCategoryData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createPartsData(String? name, String desc, int? id) async {
    try {
      String body = jsonEncode(
          {"name": name, "note": desc, "platform": "TaskerApp", "status": "1"});
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vehicle-parts-list/$id";
        response = await apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vehicle-parts-list";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }

      debugPrint("createPartsData apiUrl: $apiUrl");
      debugPrint("createPartsData body: $body");
      if (response != null) {
        debugPrint('createPartsData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('createPartsData api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createPartsData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteParts(int? partId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle-parts-list/$partId";

      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteParts api.response.body: ${response.body}');
          debugPrint('deleteParts api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteParts.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteCategory(int? catId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses_category/$catId";
      debugPrint("deleteCategory apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('deleteCategory api.response.body: ${response.body}');
          debugPrint('deleteCategory api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse =
          // GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteCategory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createSupplyData(String? name, String desc, int? id) async {
    try {
      String body = jsonEncode({
        "name": name,
        "description": desc,
        "platform": "TaskerApp",
        "status": "1"
      });
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vehicle-supplies/$id";
        response = await apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vehicle-supplies";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }

      debugPrint("createSupplyData apiUrl: $apiUrl");
      debugPrint("createSupplyData body: $body");
      if (response != null) {
        debugPrint('createSupplyData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('createSupplyData api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createSupplyData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteSupply(int? partId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle-supplies/$partId";
      debugPrint("deleteSupply apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteSupply api.response.body: ${response.body}');
          debugPrint('deleteSupply api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteSupply.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> setDefaultVehicleStatusConfig(String? vinNumber) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}setDefaultVehicleConfig/$vinNumber";
      debugPrint("setDefaultVehicleStatusConfig apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callPostMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint(
              'setDefaultVehicleStatusConfig api.response.body: ${response.body}');
          debugPrint(
              'setDefaultVehicleStatusConfig api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          if (generalResponse.message != null ||
              generalResponse.message!.isNotEmpty) {
            Utils.showMobileToast(generalResponse.message!);
            return true;
          } else {
            Utils.showMobileToast(generalResponse.error ?? '');
            return false;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('setDefaultVehicleStatusConfig.exception : ${error.toString()}');
      return null;
    }
  }

  ///category_id: "2", label: "test", task: "buy", status: 1}
  Future<bool?> createVehicleStatus(String categoryId, String? label,
      String? task, String? status, int? id) async {
    try {
      String body = jsonEncode({
        "category": categoryId,
        "checklist": label,
        "task": task,
        "status": status,
        "platform": "TaskerApp",
      });
      String apiUrl = '';
      http.Response? response;
      print('========================================================,$body');
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vehicle_status_checklist_store/$id";
        response = await apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vehicle_status_checklist_store";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      debugPrint("createVehicleStatus apiUrl: $apiUrl");
      debugPrint("createVehicleStatus body: $body");
      if (response != null) {
        debugPrint('createVehicleStatus api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createVehicleStatus api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createVehicleStatus.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleNotesHistoryResponse?> getVehicleNotesHistory(
      String? vin) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}vehicle_notes_history/$vin";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VehicleNotesHistoryResponse vehicleNotesHistoryResponse =
              VehicleNotesHistoryResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          print(
              'getVehicleHistoryList api.statusCode: $vehicleNotesHistoryResponse');
          return vehicleNotesHistoryResponse;

          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleGroupingResponse?> getVehicleGroupData() async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.BASE_URL}group-vehicle";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('VehicleGroupData api.response.body: ${response.body}');
          debugPrint('VehicleGroupData api.statusCode: ${response.statusCode}');
          VehicleGroupingResponse vehicleGroupingResponse =
          VehicleGroupingResponse.fromJson(json.decode(response.body));
          return vehicleGroupingResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('VehicleGroupData.exception : ${error.toString()}');
      return null;
    }
  }

}
