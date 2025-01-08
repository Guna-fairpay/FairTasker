
import 'package:equatable/equatable.dart';

abstract class TuroReservationState extends Equatable {
  const TuroReservationState();

  @override
  List<Object?> get props => [];
}

class TuroReservationInitial extends TuroReservationState {
  @override
  List<Object> get props => [];
}

class TuroReservationLoading extends TuroReservationState {}

class TuroReservationLoaded extends TuroReservationState {
  final String message; // Define DashboardData as a list

  const TuroReservationLoaded(
      {required this.message}); // Define named parameter in constructor

  @override
  List<Object?> get props => [message];
}

class TuroReservationError extends TuroReservationState {
  final String message;

  const TuroReservationError(this.message);

  @override
  List<Object> get props => [message];
}

