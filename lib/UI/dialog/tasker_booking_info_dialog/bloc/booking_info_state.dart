part of 'booking_info_bloc.dart';

abstract class BookingInfoState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends BookingInfoState {}

class ErrorState extends BookingInfoState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends BookingInfoState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}