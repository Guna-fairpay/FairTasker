
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class VoiceToTextEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceToTextInitialEvent extends VoiceToTextEvent {
  final String? startDate;
  final String? endDate;
  VoiceToTextInitialEvent({this.startDate, this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class ChangeDateRangeEvent extends VoiceToTextEvent {
  final DateRange selectedRange;
  ChangeDateRangeEvent(this.selectedRange);
  @override
  List<Object?> get props => [selectedRange];
}
