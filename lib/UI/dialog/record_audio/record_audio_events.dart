import 'package:equatable/equatable.dart';

abstract class RecordAudioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecordAudioRecordEvent extends RecordAudioEvent {}
class RecordAudioStopEvent extends RecordAudioEvent {}
class RecordAudioSubmitEvent extends RecordAudioEvent {}
class RecordAudioResetEvent extends RecordAudioEvent {}