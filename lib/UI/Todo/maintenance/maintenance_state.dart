import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MaintenanceState extends Equatable {
  final List<Map<String, dynamic>>? maintenance;
  final Map<String, dynamic> todoItems;
  final Map<String, dynamic> vehicle;
  final bool isAllCheck;
  final Map<String, bool> individualCheckStates;
  final List<Map<String, dynamic>> data;
  final List<dynamic> maintenanceListData;
  final Map<int, Map<int, bool>> checkboxStates;
  final Map<dynamic, String> selectedDropdownValues;
  final dynamic dropdownValue;
  final int? selectedId;
  final bool isLoading;
  final dynamic createFixTaskData;
  final Map<int,TextEditingController> notesControllers;
  final List<int>? idList;
  final String? initialDropDown;

  const MaintenanceState({
    this.maintenance,
    required this.todoItems,
    required this.vehicle,
    this.isAllCheck = false,
    this.individualCheckStates = const {},
    this.data = const [],
    this.maintenanceListData = const [],
    this.checkboxStates = const {},
    this.selectedDropdownValues = const {},
    this.dropdownValue,
    this.selectedId,
    this.idList,
    this.isLoading = false,
    this.createFixTaskData,
    this.notesControllers=const {},
    this.initialDropDown,
  });

  MaintenanceState copyWith({
    List<Map<String, dynamic>>? maintenance,
    Map<String, dynamic>? todoItems,
    Map<String, dynamic>? vehicle,
    bool? isAllCheck,
    Map<String, bool>? individualCheckStates,
    List<Map<String, dynamic>>? data,
    List<dynamic>? maintenanceListData,
    Map<int, Map<int, bool>>? checkboxStates,
    Map<dynamic, String>? selectedDropdownValues,
    dynamic dropdownValue,
    int? selectedId,
    String? maintenanceTaskId,
    bool? isLoading,
    dynamic createFixTaskData,
    Map<int,TextEditingController>? notesControllers,
    String? initialDropDown,
    List<int>? idList,
  }) =>
    MaintenanceState(
      maintenance: maintenance ?? this.maintenance,
      todoItems: todoItems ?? this.todoItems,
      vehicle: vehicle ?? this.vehicle,
      isAllCheck: isAllCheck ?? this.isAllCheck,
      individualCheckStates: individualCheckStates ?? this.individualCheckStates,
      data: data ?? this.data,
      maintenanceListData: maintenanceListData ?? this.maintenanceListData,
      checkboxStates: checkboxStates ?? this.checkboxStates,
      selectedDropdownValues: selectedDropdownValues ?? this.selectedDropdownValues,
      dropdownValue: dropdownValue ?? this.dropdownValue,
      selectedId: selectedId ?? this.selectedId,
      idList: idList ?? this.idList,
      isLoading: isLoading ?? this.isLoading,
      createFixTaskData: createFixTaskData ?? this.createFixTaskData,
      notesControllers: notesControllers ?? this.notesControllers,
      initialDropDown: initialDropDown ?? this.initialDropDown,
    );


  @override
  List<Object?> get props => [
    maintenance,
    todoItems,
    vehicle,
    isAllCheck,
    individualCheckStates,
    data,
    maintenanceListData,
    checkboxStates,
    selectedDropdownValues,
    dropdownValue,
    selectedId,
    isLoading,
    createFixTaskData,
    notesControllers,
    initialDropDown,
    idList,
  ];
}