
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditTodoState extends Equatable {
  final bool isLoading;
  final bool isTimeSensitive;
  final List<dynamic> tasks;
  final List<dynamic> vehicles;
  final List<dynamic> persons;
  final List<dynamic> vendors;
  final List<dynamic> locations;
  final List<dynamic> partServices;
  final List<dynamic> supplies;
  final List<dynamic> resources;
  final List<dynamic> linkOptions;
  final List<dynamic> selectedTaskPersons;
  final List<dynamic> selectedParts;
  final List<dynamic> selectedSupplies;
  final List<dynamic> attachments;
  final List<Map<String, dynamic>> selectedVPerson;
  final Map<int, dynamic> selectedVendor;
  final List<Map<String, dynamic>> selectedTask;
  final Map<String, dynamic> apiResponse;
  final dynamic selectedLinkOption;
  final bool showPlatformCheck;
  final bool isSelectedPlatformCheck;
  final bool isMoreEnable;
  final bool isPartServiceEnable;
  final bool isSuppliesEnable;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const EditTodoState({
    required this.isLoading,
    required this.isTimeSensitive,
    required this.tasks,
    required this.vendors,
    required this.persons,
    required this.vehicles,
    required this.locations,
    required this.partServices,
    required this.supplies,
    required this.resources,
    required this.linkOptions,
    required this.selectedVPerson,
    required this.selectedVendor,
    required this.selectedTaskPersons,
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
    required this.attachments,
    required this.apiResponse,

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
    List<Map<String, dynamic>>? selectedTask,
    List<Map<String, dynamic>>? selectedVPerson,
    Map<int, dynamic>? selectedVendor,
    List<dynamic>? tasks,
    List<dynamic>? vehicles,
    List<dynamic>? persons,
    List<dynamic>? vendors,
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
    List<dynamic>? attachments,
    List<dynamic>? addresses,
    List<dynamic>? selectedRecurringDays,
    Map<String, dynamic>? apiResponse,
    dynamic selectedRecurring,
    dynamic recurringYearlySelectedMonth,
    bool? isRecurringMonthOccurrence,
    bool? isRecurringEndDate,
    DateTime? selectedRecurringEndDate,
  }) =>
      EditTodoState(
        isLoading: isLoading ?? this.isLoading,
        isTimeSensitive: isTimeSensitive ?? this.isTimeSensitive,
        selectedVPerson: selectedVPerson ?? this.selectedVPerson,
        selectedVendor: selectedVendor ?? this.selectedVendor,
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
        attachments: attachments ?? this.attachments,
      );

  @override
  List<Object?> get props => [
    // showAppBar,
    selectedVPerson,
    selectedVendor,
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
    isSelectedPlatformCheck,
    showPlatformCheck,
    isMoreEnable,
    isPartServiceEnable,
    isSuppliesEnable,
    selectedTask,
    selectedDate,
    selectedTime,
    selectedParts,
    selectedSupplies,
    selectedTaskPersons,
    attachments,
    apiResponse,

    Random().nextDouble()
  ];
}
