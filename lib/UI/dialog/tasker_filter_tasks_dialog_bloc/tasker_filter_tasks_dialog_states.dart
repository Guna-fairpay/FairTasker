part of 'tasker_filter_tasks_dialog_bloc.dart';
abstract class TFTDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TFTDLoadingState extends TFTDStates {}
class TFTDSuccessState extends TFTDStates {
  final dynamic message;
  TFTDSuccessState(this.message);
  @override
    List<Object?> get props => [message, Random().nextDouble()];
}
class TFTDErrorState extends TFTDStates {
  final dynamic message;
  TFTDErrorState(this.message);
  @override
    List<Object?> get props => [message, Random().nextDouble()];
}

class TFTDCommonState extends TFTDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TFTDTriggerSelectedState extends TFTDStates {
  final List<dynamic>? value;
  TFTDTriggerSelectedState(this.value);
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}

class TimeSensitiveState extends TFTDStates {
  final bool value;
  TimeSensitiveState(this.value);
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}