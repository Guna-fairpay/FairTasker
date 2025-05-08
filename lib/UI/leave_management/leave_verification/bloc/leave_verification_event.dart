
import 'package:equatable/equatable.dart';

abstract class LeaveVerificationEvent extends Equatable{
   @override
  List<Object> get props => [];
}

class LeaveVerificationInitialEvent extends LeaveVerificationEvent{
  final dynamic data;
  LeaveVerificationInitialEvent({this.data});
  @override
  List<Object> get props => [data];
}

class LeaveVerificationStatusChangeEvent extends LeaveVerificationEvent {
  final dynamic selectedData;
  LeaveVerificationStatusChangeEvent({this.selectedData});
  @override
  List<Object> get props => [selectedData];
}

class LeaveVerificationSubmitEvent extends LeaveVerificationEvent {}