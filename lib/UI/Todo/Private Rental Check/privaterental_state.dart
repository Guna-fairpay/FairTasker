import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PrivateRentalsState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>>? getPrivateRentalCheckData;
  final Map<int, bool> checkBoxStates;
  final Map<int, TextEditingController> privateRentalNoteControllers;
  final Map<String, dynamic>? todoItem;
  final Map<String, dynamic>? vehicle;
  final bool pop;

  const PrivateRentalsState({
    this.isLoading = false,
    this.getPrivateRentalCheckData,
    this.checkBoxStates = const {},
    this.privateRentalNoteControllers = const {},
    this.todoItem,
    this.vehicle,
    this.pop = false,
  });

  PrivateRentalsState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? getPrivateRentalCheckData,
    Map<int, bool>? checkBoxStates,
    Map<int, TextEditingController>? privateRentalNoteControllers,
    Map<String, dynamic>? todoItem,
    Map<String, dynamic>? vehicle,
    bool? pop,
  }) {
    return PrivateRentalsState(
      isLoading: isLoading ?? this.isLoading,
      getPrivateRentalCheckData: getPrivateRentalCheckData ?? this.getPrivateRentalCheckData,
      checkBoxStates: checkBoxStates ?? this.checkBoxStates,
      privateRentalNoteControllers: privateRentalNoteControllers ?? this.privateRentalNoteControllers,
      todoItem: todoItem ?? this.todoItem,
      vehicle: vehicle ?? this.vehicle,
      pop: pop ?? this.pop,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    getPrivateRentalCheckData,
    checkBoxStates,
    privateRentalNoteControllers,
    todoItem,
    vehicle,
    pop,
  ];
}