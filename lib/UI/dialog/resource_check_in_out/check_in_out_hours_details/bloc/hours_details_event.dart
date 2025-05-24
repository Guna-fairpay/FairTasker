part of 'hours_details_bloc.dart';

abstract class HourDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends HourDetailsEvent {
  final dynamic model;
  final DateRange? dateRange;
  InitialEvent({required this.model, this.dateRange});
  @override
  List<Object?> get props => [model, dateRange];
}