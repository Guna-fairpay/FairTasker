import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/enums/task_enum.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';
part 'add_todo_mixin.dart';

class AddToDoBloc extends Bloc<AddToDoEvent, AddToDoState> with AddToDoMixin {

  AddToDoBloc() : super(LoadingState()) {
    _registerEvent(); /// REGISTER BROADCAST EVENT
    on<InitialEvent>(_onInitialEvent); /// INITIAL EVENT
    on<RefreshEvent>(_onRefreshEvent); /// REFRESH EVENT
    on<IdentifierEvent>(_onIdentifierEvent); /// IDENTIFIER EVENT
    on<PartStatusEvent>(_onPartStatusEvent); /// PART STATUS EVENT
    on<SupplyStatusEvent>(_onSupplyStatusEvent); /// SUPPLY STATUS EVENT
    on<MoreEvent>(_onMoreEvent); /// MORE EVENT
    on<TaskManagerEvent>(_onTaskManagerEvent); /// TASK MANAGER EVENT
    on<PlatformCheckEvent>(_onPlatformCheckEvent); /// PLATFORM CHECK EVENT
    on<RecurringEvent>(_onRecurringEvent); /// RECURRING EVENT
    on<DateSelectEvent>(_onDateSelectEvent); /// DATE SELECT EVENT
    on<TimeSelectEvent>(_onTimeSelectEvent); /// TIME SELECT EVENT
    on<CustomEvent>(_onCustomEvent); /// CUSTOM EVENT
    on<RecurringDaysEvent>(_onRecurringDaysEvent); /// RECURRING DAYS EVENT
    on<RecurringMonthlyEvent>(_onRecurringMonthlyEvent); /// RECURRING MONTHLY EVENT
    on<RecurringYearlyEvent>(_onRecurringYearlyEvent); /// RECURRING YEARLY EVENT
    on<RecurringEndAfterEvent>(_onRecurringEndAfterEvent); /// RECURRING END AFTER EVENT
    on<RecurringEndDateEvent>(_onRecurringEndDateEvent); /// RECURRING END DATE EVENT
    on<ClearVLEvent>(_onClearVLEvent); /// CLEAR VL EVENT
    on<VendorLocationEvent>(_onVendorLocationEvent); /// VENDOR LOCATION EVENT
    on<VehiclePersonEvent>(_onVehiclePersonEvent); /// VEHICLE PERSON EVENT
    on<TimeSensitiveEvent>(_onTimeSensitiveEvent); /// TIME SENSITIVE EVENT
    on<ViewAttachmentEvent>(_onViewAttachmentEvent); /// VIEW ATTACHMENT EVENT
    on<AddAttachmentEvent>(_onAddAttachmentEvent); /// ADD ATTACHMENT EVENT
    on<CleanCarDurationEvent>(_onCleanCarDurationEvent); /// CLEAN CAR DURATION EVENT
    on<NewPartsEvent>(_onNewPartsEvent); /// NEW PARTS EVENT
    on<NewSuppliesEvent>(_onNewSuppliesEvent); /// NEW SUPPLIES EVENT
    on<PartsEvent>(_onPartsEvent); /// PARTS EVENT
    on<SuppliesEvent>(_onSuppliesEvent); /// SUPPLIES EVENT
    on<LeadEvent>(_onLeadEvent); /// LEAD EVENT
    on<MeetingEvent>(_onMeetingEvent); /// MEETING EVENT
    on<OpenCustomLinkEvent>(_onOpenCustomLinkEvent); /// OPEN CUSTOM LINK EVENT
    on<AddressEvent>(_onAddressEvent); /// ADDRESS EVENT
    on<CleanCarEvent>(_onCleanCarEvent); /// CLEAN CAR EVENT
    on<ReassignEvent>(_onReassignEvent); /// REASSIGN EVENT
    on<DeleteTodoEvent>(_onDeleteTodoEvent); /// DELETE TODO_EVENT
    on<DeleteAttachmentEvent>(_onDeleteAttachmentEvent); /// DELETE ATTACHMENT EVENT
    on<RemoveIdentifierEvent>(_onRemoveIdentifierEvent); /// REMOVE IDENTIFIER EVENT
    on<MeetingDurationEvent>(_onMeetingDurationEvent); /// MEETING DURATION EVENT
    on<NavigateTaskEvent>(_onNavigateTaskEvent); /// NAVIGATE TASK EVENT
    on<SubmitEvent>(_onSubmitEvent); /// SUBMIT EVENT
  }

  @override
  Future<void> close() {
    _broadcast.unregister(Str.addToDoRefresh);
    return super.close();
  }

  /// LISTEN TO BROADCAST EVENT
  void _registerEvent() {
    _broadcast.register(Str.addToDoRefresh, (value, callback) => add(RefreshEvent()));
  }

  void _onInitialEvent(InitialEvent event, Emitter<AddToDoState> emit) async {
    try {
      taskType = event.taskType;
      isNextTask = event.isNextTask;
      selectedDate = event.selectedDate ?? DateTime.now();
      selectedVPerson = event.selectedVPerson ?? [];
      selectedTaskManagers.add(persons.firstWhereOrNull((element) => element['id'] == userId) ?? {});
      emit(LoadingState());
      await _fetchAllApis();
      if (isMeeting) {
        final task = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == 80) && (element['type'] == "task"));
        selectedTaskIdentifier[1] = task ?? {};
        selectedTaskIdentifiers.insert(0, task ?? {});
        taskNameController.text = task?['name'] ?? "";
      }
      if (isLeadTask && event.leadId != null) {
        final lead = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == event.leadId) && (element['type'] == "lead"));
        selectedLead = lead?['value'] ?? {};
        selectedTaskIdentifier[1] = {};
        selectedTaskIdentifier[2] = lead ?? {};
        selectedTaskIdentifier[3] = {};
        selectedTaskIdentifiers.insert(0, {});
        selectedTaskIdentifiers.insert(1, lead ?? {});
        selectedTaskIdentifiers.insert(2, {});
      }
      emit(CommonState());
      _updateReservation(emit);
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onRefreshEvent(RefreshEvent event, Emitter<AddToDoState> emit) async {
    try {
      emit(LoadingState());
      await _fetchAllApis();
      emit(CommonState());
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onSubmitEvent(SubmitEvent event, Emitter<AddToDoState> emit) async {
    try {
      _validate(emit);
      if (formKey.currentState?.validate() == false) return emit(ErrorState("All fields are required"));
      if (isCurrentDate && lasVehicleVin.isNotNullOrEmpty && isCleanCar) return add(CleanCarEvent());
      if (hasOilChange && lasVehicleVin.isNotNullOrEmpty && !event.oilChangeOverride) {
        final response = await _getOilChangeTask(vin: lasVehicleVin);
        if (response?.isEmpty ?? false) return add(SubmitEvent(oilChangeOverride: true));
        return emit(OilChangeTaskExistState(response));
      }
      final images = attachments.whereType<File>().map((e) => {"images" : e.path}).toList();
      final response = await _apiRepository.addToDo(body: _addTodoBody(), infusedFiles: images);
      final isSuccess = response?['status'] == 200;
      if (isSuccess) TaskerHelper.instance.refresh();
      emit(isSuccess ? SuccessState(response?['message'] ?? "Success") : ErrorState(response?['message'] ?? "Error occurred!"));
      await Future.delayed(Durations.short1);
      if (isSuccess) return emit(CompletedState());
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onCleanCarEvent(CleanCarEvent event, Emitter<AddToDoState> emit) async {
    try {
      if (formKey.currentState?.validate() == false) return emit(ErrorState("All fields are required"));
      if (!hasVehicle) return emit(ErrorState("Please select a vehicle"));
      if (isCurrentDate && (lasVehicleVin.isNotNullOrEmpty)) {
        final response = await _findClearCarExist(lasVehicleVin);
        if ((response?['status'] == true) && (response?['data'] != null)) {
          var lastBody = response?['data'];
          return emit(CleanTaskReassignState(lastBody));
        }
      }
      emit(LoadingState());
      final response = await _apiRepository.cleanCar(body: _cleanCarBody());
      final isSuccess = (response?['status'] == 200);
      if (isSuccess) TaskerHelper.instance.refresh();
      return emit(isSuccess ? SuccessState(response?['message'] ?? "Success") : ErrorState(response?['message'] ?? "Error occurred!"));
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onReassignEvent(ReassignEvent event, Emitter<AddToDoState> emit) async {
    try {
      emit(LoadingState());
      final body = (event.isSaveEvent ?? false) ? _addTodoBody() : _cleanCarBody();
      body['reason'] = event.reasonMessage ?? "";
      final reasonImages = event.reasonFiles?.whereType<File>().map((e) => {"reason_images" : e.path}).toList() ?? [];
      List<Map<String, dynamic>> bodyAttachments = [];
      if (event.isSaveEvent ?? false) { // SAVE WITH REASON AND FILES
        final images = attachments.whereType<File>().map((e) => {"images" : e.path}).toList();
        bodyAttachments = [...images, ...reasonImages];
      } else { // CREATE CLEAN CAR WITH REASON AND IMAGES
        bodyAttachments = reasonImages;
      }
      final response = await _apiRepository.addToDo(body: body, infusedFiles: bodyAttachments);
      final isSuccess = response?['status'] == 200;
      if (isSuccess) TaskerHelper.instance.refresh();
      emit(isSuccess ? SuccessState(response?['message'] ?? "Success") : ErrorState(response?['message'] ?? "Error occurred!"));
      await Future.delayed(Durations.short1);
      return emit(CompletedState());
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onDeleteTodoEvent(DeleteTodoEvent event, Emitter<AddToDoState> emit) async {
    try {
      emit(LoadingState());
      final response = await _deleteToDo(todoId: event.model?['id']);
      final isSuccess = response?['status'] == 200;
      if (isSuccess) {
        return add(SubmitEvent(oilChangeOverride: true));
      } else {
        return emit(ErrorState(response?['message'] ?? "Error occurred!"));
      }
    } catch (e) {
      _errorCatch(e, emit);
    }
  }
}