


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CheckListState extends Equatable {
  final List<Map<String, dynamic>>? checkListData;
  final Map<String, dynamic>? todoItems;
  final Map<String, dynamic>? vehicle;
  final bool isLoading;
  final Map<int, bool>? checkBoxStates;
  final Map<int,TextEditingController>? notesControllers;
  final List<String> notesValues;

  const CheckListState({
    this.checkListData,
    this.todoItems,
    this.vehicle,
    this.isLoading = true,
    this.checkBoxStates = const {},
    this.notesControllers = const {},
    this.notesValues = const [],
});
  CheckListState copyWith({
    List<Map<String, dynamic>>? checkListData,
    Map<String, dynamic>? todoItems,
    Map<String, dynamic>? vehicle,
    bool? isLoading,
    Map<int, bool>? checkBoxStates,
    Map<int,TextEditingController>? notesControllers,
    List<String>? notesValues,
}) => CheckListState(
    checkListData: checkListData ?? this.checkListData,
    todoItems: todoItems ?? this.todoItems,
    vehicle: vehicle ?? this.vehicle,
    isLoading: isLoading ?? this.isLoading,
    checkBoxStates: checkBoxStates ?? this.checkBoxStates,
    notesControllers: notesControllers ?? this.notesControllers,
    notesValues: notesValues ?? this.notesValues,
);

  @override
  List<Object?> get props => [checkListData,
    todoItems,
    vehicle,
    isLoading,
    checkBoxStates,
    notesControllers,
    notesValues,
  ];
}