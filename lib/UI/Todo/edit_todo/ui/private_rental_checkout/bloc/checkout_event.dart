part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CheckoutEvent{
  final dynamic data;
  InitialEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ParentCheckEvent extends CheckoutEvent{
  final dynamic data;
  ParentCheckEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ChildCheckEvent extends CheckoutEvent{
  final dynamic data;
  ChildCheckEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class YesNoEvent extends CheckoutEvent{
  final dynamic data;
  YesNoEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class DropdownEvent extends CheckoutEvent{
  final dynamic data;
  final dynamic selectedData;
  DropdownEvent({required this.data, required this.selectedData});
  @override
  List<Object?> get props => [data, selectedData];
}

class FilePickerEvent extends CheckoutEvent {}

class DeleteImageEvent extends CheckoutEvent{
  final dynamic data;
  DeleteImageEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ApproveAndCloseEvent extends CheckoutEvent {}

class SaveEvent extends CheckoutEvent {
  final bool isApprove;
  SaveEvent({this.isApprove = false});
  @override
  List<Object?> get props => [isApprove];
}