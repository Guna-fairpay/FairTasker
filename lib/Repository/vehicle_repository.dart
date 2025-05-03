import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
import 'package:permission_handler/permission_handler.dart';

import '../Response/todo_list_response.dart';
import '../Response/vehicle_grouping_response.dart';

class VehicleDataRepo {
  ApiClient apiClient = ApiClient();

  Future<CreateVehicleResponse?> createVehicle(
      CreateVehicleData createVehicleData) async {
    try {
      String apiUrl = '';
      if (createVehicleData.id != null) {
        log("vehicle update");
        apiUrl = "${Str.LIST_BASE_URL}vehiclesApi/${createVehicleData.id}";
      }
      print("Repository side Triggered ${createVehicleData.oilGrade} ${createVehicleData.oilChangeOdometer} ${createVehicleData.carNumber} ${createVehicleData.vehicleNumber}");
      Map<String, String> reqMap = {
        "vehicle_id": createVehicleData.vehicleId,
        "vin": createVehicleData.vin,
        "make": createVehicleData.make,
        "model": createVehicleData.model,
        "year": createVehicleData.year,
        "cohort_id": createVehicleData.cohortId.toString(),
        "earnings": createVehicleData.earnings,
        "utilization_rate": createVehicleData.utilizationRate,
        "platform": createVehicleData.platform,
        "mileage": createVehicleData.mileage,
        "wholesale_amount": createVehicleData.wholesaleAmount,
        "vehicle_status": createVehicleData.selectedVehicleStatus.toString(),
        "active": createVehicleData.isActive.toString(),
        "purchase_price": createVehicleData.purchasePrice.toString(),
        "purchase_date": createVehicleData.purchaseDate.toString(),
        "vehicle_number": createVehicleData.vehicleNumber,
        "address": createVehicleData.address,
        "bouncie": createVehicleData.bouncie.toString(),
        "air_tag": createVehicleData.airTag.toString(),
        "spare_tire": createVehicleData.spareTire.toString(),
        "spare_key": createVehicleData.spareKey.toString(),
        "permanent_plate": createVehicleData.permanentPlate.toString(),
        "car_number": createVehicleData.carNumber.toString(),
        "oil_grade": createVehicleData.oilGrade.toString(),//
        "registration_renewal_date": createVehicleData.regStickerDate.toString(),
        "toll_tags": createVehicleData.tollTag.toString(),
        "toll_tags_id": createVehicleData.tollTagsId.toString(),
        "front_license_plate": createVehicleData.frontLicensePlate.toString(),
        "tire_size": createVehicleData.tireSize.toString(),
        "front_tire": createVehicleData.frontTire,
        "rear_tire": createVehicleData.rearTire,
        "insurance_agent": createVehicleData.insuranceAgent.toString(),
        "insurance_cost": createVehicleData.insuranceCost.toString(),
        "employee_id" : createVehicleData.employeeId.toString(),
        "branch_code": createVehicleData.branchCode.toString(),
        "platform_from": 'TaskerApp',
        "current_odometer": createVehicleData.currentOdometer,
        "oil_change_odometer": createVehicleData.oilChangeOdometer,
        "maintenance_check": createVehicleData.maintenanceCheck,
      };
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());

      request.fields.addAll(reqMap);


      request.files.addAll(
          createVehicleData.vehicleImage.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                  "images[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last)).toList());
      request.files.addAll(
          createVehicleData.purchaseReceiptsImage.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                  "files[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last)).toList());

      request.files.addAll(
          createVehicleData.tollImage.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                  "toll_images[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last)).toList());

      request.files.addAll(
          createVehicleData.tireImage.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                  "tyre_images[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last)).toList());

      request.files.addAll(
          createVehicleData.insuranceImage.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                  "insurance_agent_images[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last)).toList());

      request.files.addAll(createVehicleData.uploadRegSticker.whereType<File>().map((e) =>
              http.MultipartFile.fromBytes(
                "registration_documents[]", e.readAsBytesSync(), filename: e.path
                  .split('/')
                  .last
              )
        ).toList()
      );

      // Add files to the request
      // for (int i = 0; i < (createVehicleData.chosenFiles.length); i++) {
      //   var file = createVehicleData.chosenFiles[i];
      //
      //   var multipartFile = http.MultipartFile.fromBytes(
      //     'toll_images[$i],tyre_images[$i],registration_documents[$i],insurance_agent_images[$i]',
      //     (await file.readAsBytes()).toList(),
      //     filename: file.path
      //         .split('/')
      //         .last,
      //   );
      //   request.files.add(multipartFile);
      // }

      var response = await request.send();
      debugPrint('createVehicle.statusCode: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        CreateVehicleResponse createVehicleResponse = CreateVehicleResponse();
        log('createVehicle.response.body: ${await response.stream.bytesToString()}');
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

  Future<bool?> moveRental({
    dynamic rentalData
  }
 ) async {
    try {
      String body = jsonEncode({
        "branch_code":rentalData['branch_code'],
        "cohort_id":rentalData['cohort_id'],
        "purchase_date":rentalData['purchase_date'],
        "purchase_price":rentalData['purchase_price'],
        "vehicle_status":rentalData['vehicle_status'],
        "rental_status": rentalData['rental_status'],
        "vehicle_number": rentalData['vehicle_number'],
        "vehicle_id": rentalData['vehicle_id'],
        "vin": rentalData['vin'],
        "make": rentalData['make'],
        "model": rentalData['model'],
        "year": rentalData['year'],
        "platform_from": "TaskerApp"
      });
      String apiUrl = "${Str.LIST_BASE_URL}vehiclesApi/${rentalData['id']}";
      http.Response? response= await apiClient.callPostMethod(apiUrl, body: body);
      debugPrint("vehiclesApi apiUrl: $apiUrl");
      if (response != null) {
          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          Utils.showMobileToast(generalResponse.message.toString());
          return true;
      } else {
        Utils.showMobileToast('Response Null');
        return null;
      }
    } catch (error) {
      log('deleteVehicleImages.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createVehicleGroup(String? name,List<String>? list,int? id) async {
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
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          Utils.showMobileToast(generalResponse.message!);
          return true;

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
          return true;
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
          debugPrint('deleteExpenseImages api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showNoResultFound();}
          return true;
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
          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
           Utils.showMobileToast(generalResponse.message??'');
          return true;
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

  Future<VehicleHistoryResponse?> getVehicleHistoryList(String? pageNo,
      String? vin,) async {
    try {
      String apiUrl = '';
      apiUrl =
      "${Str.BASE_URL}get-vehicle-history?page=$pageNo&vin=$vin&itemPerPage=20";
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

  Future<TodoListResponse?> getVehicleHistory(String? vin,
      int? vehicleGroupId) async {
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

  Future<bool?> createSubCategoryData(String? name, String? expenseTo,
      String? parentId, int? id) async {
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
              'setDefaultVehicleStatusConfig api.response.body: ${response
                  .body}');
          debugPrint(
              'setDefaultVehicleStatusConfig api.statusCode: ${response
                  .statusCode}');

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
