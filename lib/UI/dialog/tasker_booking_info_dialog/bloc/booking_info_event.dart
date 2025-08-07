part of 'booking_info_bloc.dart';

abstract class BookingInfoEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends BookingInfoEvent {
  final dynamic model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}