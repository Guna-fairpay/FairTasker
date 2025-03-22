import 'package:equatable/equatable.dart';

abstract class TCIODEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCIODInitialEvent extends TCIODEvents {
  final bool isCheckout;
  final Map<String, dynamic>? model;
  TCIODInitialEvent({this.isCheckout = false, this.model});
  @override
  List<Object?> get props => [isCheckout, model];
}