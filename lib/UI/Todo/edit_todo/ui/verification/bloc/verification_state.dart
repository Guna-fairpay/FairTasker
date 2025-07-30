part of 'verification_bloc.dart';

abstract class VerificationState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends VerificationState{}

class CommonState extends VerificationState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends VerificationState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends VerificationState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class AddManualPaymentState extends VerificationState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ApproveWarningState extends VerificationState{
  final dynamic data;
  ApproveWarningState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class UpdatePaymentModelState extends VerificationState{
  final dynamic data;
  UpdatePaymentModelState({this.data});
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class InsuranceDeleteState extends VerificationState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}