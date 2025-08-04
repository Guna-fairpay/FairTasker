part of 'vehicle_add_edit_bloc.dart';

abstract class VehicleAddEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VehicleAddEditEvent {
  final dynamic editModel;
  final dynamic addModel;
  InitialEvent({this.editModel, this.addModel});
  @override
  List<Object?> get props => [editModel, addModel];
}

class SelectVehicleEvent extends VehicleAddEditEvent {
  final dynamic data;
  SelectVehicleEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PickImageEvent extends VehicleAddEditEvent {}

class CaptureImageEvent extends VehicleAddEditEvent {}

class InvoiceEvent extends VehicleAddEditEvent {}

class RemoveImageEvent extends VehicleAddEditEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class SelectPaymentEvent extends VehicleAddEditEvent {
  final dynamic data;
  SelectPaymentEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SelectCategoryEvent extends VehicleAddEditEvent {
  final dynamic data;
  SelectCategoryEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SelectSubCategoryEvent extends VehicleAddEditEvent {
  final dynamic data;
  SelectSubCategoryEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SelectExpenseToEvent extends VehicleAddEditEvent {
  final dynamic data;
  SelectExpenseToEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class DatePickedEvent extends VehicleAddEditEvent {
  final dynamic date;
  DatePickedEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class SaveEvent extends VehicleAddEditEvent {}

class TodoDetailsEvent extends VehicleAddEditEvent {}

class DeleteEvent extends VehicleAddEditEvent {}

class TaxIconEvent extends VehicleAddEditEvent {}

class GetOdometerEvent extends VehicleAddEditEvent {}

class GenerateInvoiceEvent extends VehicleAddEditEvent {}