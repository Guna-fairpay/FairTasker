


import 'package:equatable/equatable.dart';

abstract class vehiclePageEvent extends Equatable {

  const vehiclePageEvent();
  @override
  List<Object?> get props => [];

}

class vehicleInitialEvent extends vehiclePageEvent {
  final Map<String, dynamic> todoItems;
  final Map<String, dynamic> vehicle;
  const vehicleInitialEvent({
    required this.todoItems,
    required this.vehicle
});
  @override
  List<Object?> get props => [todoItems, vehicle];
}