part of 'additional_picture_dialog_bloc.dart';

abstract class AdditionalPictureDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends AdditionalPictureDialogEvent{
  final List<dynamic>? precheckImages;
  InitialEvent(this.precheckImages);
  @override
  List<Object?> get props => [precheckImages];
}

class CheckEvent extends AdditionalPictureDialogEvent{
  final dynamic data;
  CheckEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class UploadEvent extends AdditionalPictureDialogEvent{}