import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';

class VehicleHistoryRepository {
  final APiRepository _aPiRepository = APiRepository();

  Future<VehicleHistoryResponse?> getVehicleHistoryList({String? vin, dynamic groupId, int? currentPage, int itemsPerPage = 5, String? search}) async =>
      await _aPiRepository.getVehicleHistoryList(vin : vin, groupId: groupId,
          currentPage: currentPage, itemsPerPage: itemsPerPage, search: search);

  Future<AssignedToResponse?> getResourcesList() async =>
      await _aPiRepository.getResourcesList();

  Future<UserGroupResponse?> getGroupPersonList() async =>
      await _aPiRepository.getGroupPersonList();

  Future<GeneralResponse?> completeToDo(dynamic todoId, {bool status = true}) async =>
      await _aPiRepository.completeToDo(todoId, status: status);

  Future<GeneralResponse?> deleteToDo(dynamic todoId, dynamic reason) async =>
      await _aPiRepository.deleteToDo(todoId, reason);
}
