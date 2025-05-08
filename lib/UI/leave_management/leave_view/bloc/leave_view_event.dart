
import 'package:equatable/equatable.dart';

abstract class LeaveViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class LeaveViewInitialEvent extends LeaveViewEvent{}

class SearchEvent extends LeaveViewEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class EmployeeSelectedEvent extends LeaveViewEvent{
  final dynamic employee;
  EmployeeSelectedEvent(this.employee);
  @override
  List<Object?> get props => [employee];
}

class AddEditPageEvent extends LeaveViewEvent{
  final dynamic leaveData;
  AddEditPageEvent({this.leaveData});
  @override
  List<Object?> get props => [leaveData];
}

class VerificationPageEvent extends LeaveViewEvent{
  final dynamic leaveData;
  VerificationPageEvent({this.leaveData});
  @override
  List<Object?> get props => [leaveData];
}

class RefreshEvent extends LeaveViewEvent{}