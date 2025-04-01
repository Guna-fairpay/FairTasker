import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class RecordAudioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecordAudioCommonState extends RecordAudioState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RecordAudioSubmittedState extends RecordAudioState {
  final File? recorded;
  RecordAudioSubmittedState(this.recorded);
  @override
  List<Object?> get props => [recorded];
}
class RecordAudioPermissionState extends RecordAudioState {}