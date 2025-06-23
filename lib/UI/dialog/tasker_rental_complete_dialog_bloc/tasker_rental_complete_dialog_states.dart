import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class TRCDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TRCDLoadingState extends TRCDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class TRCDCommonState extends TRCDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TRCDErrorState extends TRCDStates {
  final dynamic message;
  TRCDErrorState({required this.message});
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TRCDCompletedState extends TRCDStates {}

class TRCDShowAttachmentState extends TRCDStates {
  final List<dynamic> attachments;
  final dynamic type;
  TRCDShowAttachmentState({required this.attachments, this.type});
  @override
  List<Object?> get props => [attachments, type, Random().nextDouble()];
}

class TRCDNoCleanDialogState extends TRCDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ShowOdometerWarningState extends TRCDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}