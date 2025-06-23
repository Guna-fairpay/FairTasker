import 'package:equatable/equatable.dart';

abstract class PrivateRentalCheckEvent extends Equatable {
  const PrivateRentalCheckEvent();
  @override
  List<Object?> get props => [];
}

class PrivateRentalCheckInitialEvent extends PrivateRentalCheckEvent {
  final dynamic todoData;
  const PrivateRentalCheckInitialEvent({required this.todoData});
  @override
  List<Object?> get props => [todoData];
}

class RentalCheckEvent extends PrivateRentalCheckEvent {
  final dynamic model;
  final bool? isChecked;
  const RentalCheckEvent(this.model, this.isChecked);
  @override
  List<Object?> get props => [model, isChecked];
}

class PrivateRentalCheckSubmitEvent extends PrivateRentalCheckEvent {
  final dynamic model;
  const PrivateRentalCheckSubmitEvent(this.model);
  @override
  List<Object?> get props => [model];
}


class PrivateRentalCheckCompleteEvent extends PrivateRentalCheckEvent {
  final dynamic model;
  const PrivateRentalCheckCompleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PrivateRentalCheckDeleteEvent extends PrivateRentalCheckEvent {
  final dynamic model;
  final dynamic reason;
  const PrivateRentalCheckDeleteEvent(this.model, {this.reason});
  @override
  List<Object?> get props => [model, reason];
}
