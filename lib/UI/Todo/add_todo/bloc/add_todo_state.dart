import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddToDoState extends Equatable {
  final bool isLoading;
  final bool showAppBar;
  final List<dynamic> tasks;
  final List<dynamic> vPersons;
  final List<dynamic> vLocations;
  final List<dynamic> partServices;
  final List<dynamic> supplies;
  final List<dynamic> resources;
  final List<dynamic> clearDurations;
  final List<dynamic> linkOptions;
  final dynamic selectedClearDuration;
  final dynamic selectedLinkOption;
  final bool showPlatformCheck;
  final bool isSelectedPlatformCheck;
  final bool isMoreEnable;
  final bool isPartServiceEnable;
  final bool isSuppliesEnable;
  final bool showCleanCar;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const AddToDoState({
    required this.showAppBar,
    required this.isLoading,
    required this.tasks,
    required this.vLocations,
    required this.vPersons,
    required this.partServices,
    required this.supplies,
    required this.resources,
    required this.clearDurations,
    required this.linkOptions,
    this.selectedClearDuration,
    this.selectedLinkOption,
    required this.isSelectedPlatformCheck,
    required this.showPlatformCheck,
    required this.isMoreEnable,
    required this.isPartServiceEnable,
    required this.isSuppliesEnable,
    required this.showCleanCar,
    required this.selectedDate,
    required this.selectedTime,
  });

  AddToDoState copyWith({
    bool? showAppBar,
    bool? isLoading,
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
    List<dynamic>? tasks,
    List<dynamic>? vPersons,
    List<dynamic>? vLocations,
    List<dynamic>? partServices,
    List<dynamic>? supplies,
    List<dynamic>? resources,
    List<dynamic>? clearDurations,
    List<dynamic>? linkOptions,
  }) =>
      AddToDoState(
          showAppBar: showAppBar ?? this.showAppBar,
          isLoading: isLoading ?? this.isLoading,
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
          vLocations: vLocations ?? this.vLocations,
          linkOptions: linkOptions ?? this.linkOptions,
          partServices: partServices ?? this.partServices,
          resources: resources ?? this.resources,
          supplies: supplies ?? this.supplies,
          tasks: tasks ?? this.tasks,
          vPersons: vPersons ?? this.vPersons,
          selectedClearDuration:
              selectedClearDuration ?? this.selectedClearDuration,
          selectedLinkOption: selectedLinkOption ?? this.selectedLinkOption);

  @override
  List<Object?> get props => [
        showAppBar,
        isLoading,
        tasks,
        vPersons,
        vLocations,
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
        showCleanCar,
        selectedDate,
        selectedTime,
      ];
}
