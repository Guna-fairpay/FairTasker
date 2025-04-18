
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class BillEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BillInitialEvent extends BillEvent {
  final String? from;
  final String? to;
  BillInitialEvent({this.from, this.to});
  @override
  List<Object?> get props => [from, to];
}

class DateRangeEvent extends BillEvent {
  final DateRange selectedRange;
  DateRangeEvent(this.selectedRange);
  @override
  List<Object?> get props => [selectedRange];
}

class CheckBoxEvent extends BillEvent {
  final dynamic value;
  CheckBoxEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class FilePickerEvent extends BillEvent {
  final dynamic value;
  FilePickerEvent({this.value});
  @override
  List<Object?> get props => [value];
}

class DeleteBillEvent extends BillEvent {
  final dynamic value;
  DeleteBillEvent({this.value});
  @override
  List<Object?> get props => [value];
}

class AddBillEvent extends BillEvent {}

class EditBillEvent extends BillEvent {
  final dynamic value;
  EditBillEvent({this.value});
  @override
  List<Object?> get props => [value];
}

class LoadEditValueEvent extends BillEvent {
  final dynamic value;
  LoadEditValueEvent({this.value});
  @override
  List<Object?> get props => [value];
}

class ClearAllEvent extends BillEvent {}