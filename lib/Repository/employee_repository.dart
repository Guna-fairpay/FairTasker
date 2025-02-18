import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import '../Response/employee_response.dart';

class EmployeeRepository {
  ApiClient apiClient = ApiClient();

  Future<EmployeeListResponse?> getEmployee() async {
    try {
      String apiUrl = "${Str.BASE_URL}userList";
      // debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          EmployeeListResponse employeeResponse =
              EmployeeListResponse.fromJson(json.decode(response.body));

          return employeeResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<EditEmployeeResponse?> getEditEmployee({int? id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}editUser/$id";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          EditEmployeeResponse employeeResponse =
          EditEmployeeResponse.fromJson(json.decode(response.body));
          return employeeResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('userList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<EmployeeResponse?> createEmployee(
    int? id,
    String? department,
    String? email,
    String? firstname,
    String? lastname,
    String? password,
    String? phone,
    String? role,
  ) async {
    try {
      String body = jsonEncode({
        "department": department,
        "email": email,
        "first_name": firstname,
        "last_name": lastname,
        "password": password,
        "phone": phone,
        "role": role,
        "platform": "TaskerApp",
        "status": "1"
      });
      String apiUrl = "${Str.BASE_URL}addUser";
      final http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body);

      if (response != null) {
        EmployeeResponse employeeResponse =
            EmployeeResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return employeeResponse;
        } else {
          return employeeResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Employee.exception : ${error.toString()}');
      return null;
    }
  }

  Future<EmployeeResponse?> editEmployee(
    int? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phone,
    int? role,
    String? department,
  ) async {
    try {
      String body = jsonEncode({
        "first_name": firstname,
        "last_name": lastname,
        "email": email,
        "phone": phone,
        "role": role,
        "department": department,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = "${Str.BASE_URL}updateUser/$id";
      http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body);

      if (response != null) {
        EmployeeResponse employeeResponse =
            EmployeeResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return employeeResponse;
        } else {
          return employeeResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Employee.exception : ${error.toString()}');
      return null;
    }
  }

  Future<EmployeeResponse?> deleteEmployee(String? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteUser/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        EmployeeResponse employeeResponse =
            EmployeeResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return employeeResponse;
        } else {
          return employeeResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Employee.exception : ${error.toString()}');
      return null;
    }
  }
}
