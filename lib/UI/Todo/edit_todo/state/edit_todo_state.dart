
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditTodoState extends Equatable {
  final bool isLoading;
  final bool isTimeSensitive;
  final List<Map<String, dynamic>> tasks;
  final List<dynamic> vehicles;
  final List<dynamic> persons;
  final List<dynamic> vendors;
  final List<dynamic> locations;
  final List<dynamic> partServices;
  final List<dynamic> supplies;
  final List<dynamic> resources;
  final List<dynamic> linkOptions;
  final List<dynamic> bottomTapData;
  final Map<String, dynamic> selectedBottomTap;
  final List<dynamic> selectedTaskPersons;
  final List<dynamic> selectedParts;
  final List<dynamic> selectedSupplies;
  final List<dynamic> todoAttachments;
  final List<Map<String, dynamic>> selectedVPerson;
  final Map<String, dynamic> selectedVLocations;
  final Map<String, dynamic> selectedTask;
  final Map<String, dynamic> apiResponse;
  final dynamic selectedLinkOption;
  final bool showPlatformCheck;
  final bool isSelectedPlatformCheck;
  final bool isMoreEnable;
  final bool isPartServiceEnable;
  final bool isSuppliesEnable;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool todoStatus;
  final List<String> selectedResource;
  final List<dynamic> userGroup;
  final List<dynamic> resourceName;
  final List<dynamic> addresses;
  final String title;
  final List<dynamic>taskHistory;
  final dynamic selectedVehicle;
  final List<dynamic> groupVehicles;
  final List<dynamic> sentiments;
  final dynamic selectedSentiment;
  final bool popUpdatePage;
  final String previousOdometer;
  final bool showCleanCar;
  final dynamic selectedClearDuration;
  final bool isPop;
  final List<dynamic>clearDurations;
  final DateTime? selectedEndDate;
  final DateTime? selectedStartDate;
  final bool isRecurring;

  const EditTodoState( {
    required this.isLoading,
    required this.isTimeSensitive,
    required this.tasks,
    required this.vendors,
    required this.persons,
    required this.vehicles,
    required this.locations,
    required this.partServices,
    required this.bottomTapData,
    required this.supplies,
    required this.resources,
    required this.linkOptions,
    required this.selectedVPerson,
    required this.selectedVLocations,
    required this.selectedTaskPersons,
    required this.selectedBottomTap,
    required this.selectedTask,
    this.selectedLinkOption,
    required this.selectedSupplies,
    required this.selectedParts,
    required this.isSelectedPlatformCheck,
    required this.showPlatformCheck,
    required this.isMoreEnable,
    required this.isPartServiceEnable,
    required this.isSuppliesEnable,
    required this.selectedDate,
    required this.selectedTime,
    required this.todoAttachments,
    required this.apiResponse,
    required this.todoStatus,
    required this.selectedResource,
    required this.userGroup,
    required this.resourceName,
    required this.addresses,
    required this.title,
    required this.taskHistory,
    required this.selectedVehicle,
    required this.groupVehicles,
    required this.sentiments,
    required this.selectedSentiment,
    required this.popUpdatePage,
    required this.previousOdometer,
    required this.showCleanCar,
    this.selectedClearDuration,
    required this.isPop,
    required this.clearDurations,
    required this.selectedEndDate,
    required this.selectedStartDate,
    required this.isRecurring,
  });

  EditTodoState copyWith({
    bool? showAppBar,
    bool? isLoading,
    bool? redirect,
    bool? isTimeSensitive,
    bool? isSelectedPlatformCheck,
    bool? isPartServiceEnable,
    bool? isSuppliesEnable,
    bool? isMoreEnable,
    bool? showPlatformCheck,
    bool? showCleanCar,
    dynamic selectedDate,
    dynamic selectedTime,
    dynamic selectedClearDuration,
    dynamic selectedLinkOption,
    Map<String, dynamic>? selectedTask,
    List<Map<String, dynamic>>? selectedVPerson,
    Map<String, dynamic>? selectedVLocations,
    List<Map<String, dynamic>>? tasks,
    List<dynamic>? vehicles,
    List<dynamic>? persons,
    List<dynamic>? vendors,
    List<dynamic>? bottomTapData,
    Map<String, dynamic>? selectedBottomTap,
    List<dynamic>? locations,
    List<dynamic>? partServices,
    List<dynamic>? supplies,
    List<dynamic>? resources,
    List<dynamic>? clearDurations,
    List<dynamic>? linkOptions,
    List<dynamic>? selectedTaskPersons,
    List<dynamic>? selectedParts,
    List<dynamic>? selectedSupplies,
    List<dynamic>? recurringTypes,
    List<dynamic>? todoAttachments,
    List<dynamic>? addresses,
    List<dynamic>? selectedRecurringDays,
    Map<String, dynamic>? apiResponse,
    dynamic selectedRecurring,
    dynamic recurringYearlySelectedMonth,
    bool? isRecurringMonthOccurrence,
    bool? isRecurringEndDate,
    DateTime? selectedRecurringEndDate,
    bool? todoStatus,
    List<String>? selectedResource,
    List<dynamic>? userGroup,
    List<dynamic>? resourceName,
    String? title,
    List<dynamic>? taskHistory,
    dynamic selectedVehicle,
    List<dynamic>? groupVehicles,
    List<dynamic>? sentiments,
    dynamic selectedSentiment,
    bool? popUpdatePage,
    String? previousOdometer,
    bool? isRecurring,
    bool? isPop,
    DateTime? selectedEndDate,
    DateTime? selectedStartDate,

  }) =>
      EditTodoState(
        isLoading: isLoading ?? this.isLoading,
        isTimeSensitive: isTimeSensitive ?? this.isTimeSensitive,
        selectedVPerson: selectedVPerson ?? this.selectedVPerson,
        selectedVLocations: selectedVLocations ?? this.selectedVLocations,
        isSelectedPlatformCheck:
        isSelectedPlatformCheck ?? this.isSelectedPlatformCheck,
        showPlatformCheck: showPlatformCheck ?? this.showPlatformCheck,
        isMoreEnable: isMoreEnable ?? this.isMoreEnable,
        isPartServiceEnable: isPartServiceEnable ?? this.isPartServiceEnable,
        isSuppliesEnable: isSuppliesEnable ?? this.isSuppliesEnable,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedTime: selectedTime ?? this.selectedTime,
        vehicles: vehicles ?? this.vehicles,
        persons: persons ?? this.persons,
        vendors: vendors ?? this.vendors,
        bottomTapData: bottomTapData ?? this.bottomTapData,
        selectedBottomTap: selectedBottomTap ?? this.selectedBottomTap,
        locations: locations ?? this.locations,
        linkOptions: linkOptions ?? this.linkOptions,
        partServices: partServices ?? this.partServices,
        resources: resources ?? this.resources,
        supplies: supplies ?? this.supplies,
        tasks: tasks ?? this.tasks,
        apiResponse: apiResponse ?? this.apiResponse,
        selectedTask: selectedTask ?? this.selectedTask,
        selectedLinkOption: selectedLinkOption ?? this.selectedLinkOption,
        selectedTaskPersons: selectedTaskPersons ?? this.selectedTaskPersons,
        selectedSupplies: selectedSupplies ?? this.selectedSupplies,
        selectedParts: selectedParts ?? this.selectedParts,
        todoAttachments: todoAttachments ?? this.todoAttachments,
        todoStatus: todoStatus ?? this.todoStatus,
        selectedResource: selectedResource ?? this.selectedResource,
        userGroup: userGroup ?? this.userGroup,
        resourceName: resourceName ?? this.resourceName,
        addresses: addresses ?? this.addresses,
        title: title ?? this.title,
        taskHistory: taskHistory ?? this.taskHistory,
        selectedVehicle: selectedVehicle ?? this.selectedVehicle,
        groupVehicles: groupVehicles ?? this.groupVehicles,
        sentiments: sentiments ?? this.sentiments,
        selectedSentiment: selectedSentiment ?? this.selectedSentiment,
        popUpdatePage: popUpdatePage ?? this.popUpdatePage,
        previousOdometer: previousOdometer ?? this.previousOdometer,
        showCleanCar: showCleanCar ?? this.showCleanCar,
        selectedClearDuration:selectedClearDuration ?? this.selectedClearDuration,
        isPop: isPop ?? this.isPop,
        clearDurations: clearDurations ?? this.clearDurations,
        selectedEndDate: selectedEndDate ?? this.selectedEndDate,
        selectedStartDate: selectedStartDate ?? this.selectedStartDate,
        isRecurring: isRecurring ?? this.isRecurring,
      );

  @override
  List<Object?> get props => [
    selectedVPerson,
    selectedVLocations,
    isLoading,
    isTimeSensitive,
    tasks,
    vehicles,
    persons,
    vendors,
    locations,
    partServices,
    supplies,
    resources,
    linkOptions,
    selectedLinkOption,
    selectedBottomTap,
    isSelectedPlatformCheck,
    showPlatformCheck,
    isMoreEnable,
    isPartServiceEnable,
    isSuppliesEnable,
    bottomTapData,
    selectedTask,
    selectedDate,
    selectedTime,
    selectedParts,
    selectedSupplies,
    selectedTaskPersons,
    todoAttachments,
    apiResponse,
    todoStatus,
    selectedResource,
    userGroup,
    resourceName,
    addresses,
    title,
    taskHistory,
    selectedVehicle,
    groupVehicles,
    sentiments,
    selectedSentiment,
    popUpdatePage,
    previousOdometer,
    showCleanCar,
    selectedClearDuration,
    isPop,
    clearDurations,
    selectedEndDate,
    selectedStartDate,
    isRecurring,
    Random().nextDouble()
  ];
}
