import 'dart:async';

import 'package:fairpytasker/Event/header_events.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/State/header_states.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Utilities/prefs.dart';

class HeaderBloc extends Bloc<HeaderEvent, HeaderState> {
  final APiRepository _aPiRepository = APiRepository();
  List<Map<String, dynamic>> _userPunchList = [];
  var checkInCount = 0;
  var checkOutCount = 0;
  final FBroadcast _broadcast = FBroadcast.instance();
  HeaderBloc() : super(HeaderLoadingState()) {
    getIt<CommonService>().branchUpdate(callback: () => add(HeaderInitialEvent()));
    _broadcast.register(Str.userPunchListRefresh, (value, callback) => add(HeaderInitialEvent()));
   on<HeaderInitialEvent>(_onInitialEvent);
  }

  Future<List<Map<String, dynamic>>?> _getUserPunchList() async => await _aPiRepository.getUserPunchList();

  List<dynamic> get _currentBranchHrmIds => getIt<CommonService>().currentBranchHrmIds;

  void _onInitialEvent(HeaderInitialEvent event, Emitter<HeaderState> emit) async {
    try {
      emit(HeaderLoadingState());
      _userPunchList = (await _getUserPunchList()) ?? [];
      _userPunchList = _userPunchList.where((element) => _currentBranchHrmIds.contains(element['employee']?['id'])).toList();
      checkInCount = _userPunchList.where((element) => element['end_time'].toString().trim().isNullOrEmpty).length;
      checkOutCount = _userPunchList.where((element) => element['end_time'].toString().trim().isNotNullOrEmpty).length;
      Console.of.log(_userPunchList, name: "USER_PUNCH_LIST");
      Console.of.log(_currentBranchHrmIds, name: "CURRENT_BRANCH_IDS");
      Console.of.log("$checkInCount/$checkInCount", name: "CHECK_IN_OUT");
      Console.of.log(_userPunchList.map((e) => e['end_time'].toString().trim().isNullOrEmpty).join(", "), name: "USERPUNCH_1");
      Console.of.log(_userPunchList.map((e) => e['end_time'].toString().trim().isNotNullOrEmpty).join(", "), name: "USERPUNCH_2");
      emit(HeaderCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(HeaderErrorState(e));
    }
  }
}