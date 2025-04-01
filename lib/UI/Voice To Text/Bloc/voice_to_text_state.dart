
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VoiceToTextState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceToTextLoadingState extends VoiceToTextState {}

class VoiceToTextLoadedState extends VoiceToTextState {}

class VoiceToTextCommonState extends VoiceToTextState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VoiceToTextCompleteState extends VoiceToTextState {}


