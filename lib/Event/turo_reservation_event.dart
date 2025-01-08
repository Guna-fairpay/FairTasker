
import 'package:equatable/equatable.dart';

abstract class TuroReservationEvent extends Equatable {
  const TuroReservationEvent();
}

class TuroReservationInitialEvent extends TuroReservationEvent {
  @override
  List<Object?> get props => [];
}

class AddTuroReservationData extends TuroReservationEvent {
  final String data;
  final int? id;

  const AddTuroReservationData({

    required this.data,
    required this.id,
  });
  @override
  List<Object?> get props => [data,id];
}
