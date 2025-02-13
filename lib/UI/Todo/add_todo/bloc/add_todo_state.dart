import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddToDoState extends Equatable {
  final bool isLoading;
  final bool redirect;
  final bool showAppBar;
  final bool isTimeSensitive;
  final List<dynamic> tasks;
  final List<dynamic> vehicles;
  final List<dynamic> persons;
  final List<dynamic> vendors;
  final List<dynamic> locations;
  final List<dynamic> partServices;
  final List<dynamic> supplies;
  final List<dynamic> resources;
  final List<dynamic> clearDurations;
  final List<dynamic> linkOptions;
  final List<dynamic> selectedTaskPersons;
  final List<dynamic> selectedParts;
  final List<dynamic> selectedSupplies;
  final List<dynamic> recurringTypes;
  final List<dynamic> attachments;
  final List<dynamic> addresses;
  final List<dynamic> selectedRecurringDays;
  final List<Map<String, dynamic>> selectedVPerson;
  final Map<int, dynamic> selectedTaskIdentifier;
  final dynamic selectedClearDuration;
  final dynamic selectedLinkOption;
  final bool showPlatformCheck;
  final bool isSelectedPlatformCheck;
  final bool isMoreEnable;
  final bool isPartServiceEnable;
  final bool isSuppliesEnable;
  final bool showCleanCar;
  final bool isRecurringMonthOccurrence;
  final bool isRecurringEndDate;
  final DateTime? selectedDate;
  final DateTime? selectedRecurringEndDate;
  final TimeOfDay? selectedTime;
  final dynamic selectedRecurring;
  final dynamic recurringYearlySelectedMonth;

  const AddToDoState({
    required this.showAppBar,
    required this.isLoading,
    required this.redirect,
    required this.isTimeSensitive,
    required this.tasks,
    required this.vendors,
    required this.persons,
    required this.vehicles,
    required this.locations,
    required this.partServices,
    required this.supplies,
    required this.resources,
    required this.clearDurations,
    required this.linkOptions,
    required this.selectedVPerson,
    required this.selectedTaskPersons,
    this.selectedClearDuration,
    this.selectedLinkOption,
    required this.selectedSupplies,
    required this.selectedParts,
    required this.selectedTaskIdentifier,
    required this.isSelectedPlatformCheck,
    required this.showPlatformCheck,
    required this.isMoreEnable,
    required this.isPartServiceEnable,
    required this.isSuppliesEnable,
    required this.showCleanCar,
    required this.selectedDate,
    required this.selectedTime,
    required this.recurringTypes,
    required this.attachments,
    required this.addresses,
    required this.selectedRecurringDays,
    this.selectedRecurring,
    this.selectedRecurringEndDate,
    required this.isRecurringMonthOccurrence,
    required this.isRecurringEndDate,
    required this.recurringYearlySelectedMonth,
  });

  AddToDoState copyWith({
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
    Map<int, dynamic>? selectedTaskIdentifier,
    List<Map<String, dynamic>>? selectedVPerson,
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
    dynamic selectedRecurring,
    dynamic recurringYearlySelectedMonth,
    bool? isRecurringMonthOccurrence,
    bool? isRecurringEndDate,
    DateTime? selectedRecurringEndDate,
  }) =>
      AddToDoState(
        showAppBar: showAppBar ?? this.showAppBar,
        isLoading: isLoading ?? this.isLoading,
        redirect: redirect ?? this.redirect,
        isTimeSensitive: isTimeSensitive ?? this.isTimeSensitive,
        selectedVPerson: selectedVPerson ?? this.selectedVPerson,
        isSelectedPlatformCheck:
            isSelectedPlatformCheck ?? this.isSelectedPlatformCheck,
        showPlatformCheck: showPlatformCheck ?? this.showPlatformCheck,
        isMoreEnable: isMoreEnable ?? this.isMoreEnable,
        isPartServiceEnable: isPartServiceEnable ?? this.isPartServiceEnable,
        isSuppliesEnable: isSuppliesEnable ?? this.isSuppliesEnable,
        showCleanCar: showCleanCar ?? this.showCleanCar,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedTime: selectedTime ?? this.selectedTime,
        clearDurations: clearDurations ?? this.clearDurations,
        vehicles: vehicles ?? this.vehicles,
        persons: persons ?? this.persons,
        vendors: vendors ?? this.vendors,
        locations: locations ?? this.locations,
        linkOptions: linkOptions ?? this.linkOptions,
        partServices: partServices ?? this.partServices,
        resources: resources ?? this.resources,
        supplies: supplies ?? this.supplies,
        tasks: tasks ?? this.tasks,
        selectedTaskIdentifier:
            selectedTaskIdentifier ?? this.selectedTaskIdentifier,
        selectedClearDuration:
            selectedClearDuration ?? this.selectedClearDuration,
        selectedLinkOption: selectedLinkOption ?? this.selectedLinkOption,
        selectedTaskPersons: selectedTaskPersons ?? this.selectedTaskPersons,
        selectedSupplies: selectedSupplies ?? this.selectedSupplies,
        selectedParts: selectedParts ?? this.selectedParts,
        recurringTypes: recurringTypes ?? this.recurringTypes,
        selectedRecurring: selectedRecurring ?? this.selectedRecurring,
        attachments: attachments ?? this.attachments,
        addresses: addresses ?? this.addresses,
        selectedRecurringDays:
            selectedRecurringDays ?? this.selectedRecurringDays,
        recurringYearlySelectedMonth:
            recurringYearlySelectedMonth ?? this.recurringYearlySelectedMonth,
        isRecurringMonthOccurrence:
            isRecurringMonthOccurrence ?? this.isRecurringMonthOccurrence,
        isRecurringEndDate: isRecurringEndDate ?? this.isRecurringEndDate,
        selectedRecurringEndDate:
            selectedRecurringEndDate ?? this.selectedRecurringEndDate,
      );

  @override
  List<Object?> get props => [
        showAppBar,
        selectedVPerson,
        isLoading,
        redirect,
        isTimeSensitive,
        tasks,
        vehicles,
        persons,
        vendors,
        locations,
        partServices,
        supplies,
        resources,
        clearDurations,
        linkOptions,
        selectedClearDuration,
        selectedLinkOption,
        isSelectedPlatformCheck,
        showPlatformCheck,
        isMoreEnable,
        isPartServiceEnable,
        isSuppliesEnable,
        selectedTaskIdentifier,
        showCleanCar,
        selectedDate,
        selectedTime,
        selectedParts,
        selectedSupplies,
        selectedTaskPersons,
        recurringTypes,
        selectedRecurring,
        attachments,
        addresses,
        selectedRecurringDays,
        recurringYearlySelectedMonth,
        isRecurringMonthOccurrence,
        isRecurringEndDate,
        selectedRecurringEndDate,
        Random().nextDouble()
      ];
}
