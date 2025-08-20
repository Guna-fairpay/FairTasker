part of 'additional_picture_dialog_bloc.dart';

abstract class AdditionalPictureDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ErrorState extends AdditionalPictureDialogState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}

class SuccessState extends AdditionalPictureDialogState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class CommonState extends AdditionalPictureDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}