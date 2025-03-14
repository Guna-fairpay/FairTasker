




import 'package:equatable/equatable.dart';

class vehiclePageState extends Equatable {
  final Map<String, dynamic>? todoItems;
  final Map<String, dynamic>? vehicle;
  final bool isLoading;

  const vehiclePageState({
    this.todoItems,
    this.vehicle,
    this.isLoading = true,
  });

  vehiclePageState copyWith({
    Map<String, dynamic>? todoItems,
    Map<String, dynamic>? vehicle,
    bool? isLoading,
  }) => vehiclePageState(
    todoItems: todoItems ?? this.todoItems,
    vehicle: vehicle ?? this.vehicle,
    isLoading: isLoading ?? this.isLoading,
  );

  @override
  List<Object?> get props => [todoItems, vehicle, isLoading];

}