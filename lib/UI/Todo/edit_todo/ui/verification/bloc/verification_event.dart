part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VerificationEvent{
  final dynamic data;
  InitialEvent({this.data});
  @override
  List<Object?> get props => [data];
}

class TabChangeEvent extends VerificationEvent{
  final int value;
  TabChangeEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class CheckListEvent extends VerificationEvent{
  final dynamic data;
  CheckListEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ApproveEvent extends VerificationEvent{
  final dynamic data;
  final bool isDialog;
  ApproveEvent({this.data, this.isDialog = false});
  @override
  List<Object?> get props => [data, isDialog];
}

class RejectEvent extends VerificationEvent{
  final dynamic data;
  RejectEvent({this.data});
  @override
  List<Object?> get props => [data];
}

class ForceActionEvent extends VerificationEvent{}

class PaymentTypeEvent extends VerificationEvent{
  final dynamic data;
  PaymentTypeEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PaymentAttachmentEvent extends VerificationEvent{}

class RemovePaymentAttachmentEvent extends VerificationEvent{
  final dynamic data;
  RemovePaymentAttachmentEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class AddPaymentEvent extends VerificationEvent{}

class SavePaymentEvent extends VerificationEvent{}

class GenerateAgreementEvent extends VerificationEvent{
  final bool isChecked;
  GenerateAgreementEvent({this.isChecked = false});
  @override
  List<Object?> get props => [isChecked];
}

class ViewAgreementEvent extends VerificationEvent{
  final dynamic data;
  ViewAgreementEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class UpdatePaymentMethodEvent extends VerificationEvent{
  final dynamic data;
  UpdatePaymentMethodEvent(this.data);
  @override
  List<Object?> get props => [data];
}