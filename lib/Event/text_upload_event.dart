
import 'package:equatable/equatable.dart';

abstract class TextUploadEvent extends Equatable {
  const TextUploadEvent();
}

class TextUpload extends TextUploadEvent {
  final String text;

  const TextUpload({required this.text});

  @override
  List<Object?> get props => [text];
}

class TuroReservationEvent extends TextUploadEvent {
  final String text;
  const TuroReservationEvent({required this.text,});

  @override
  List<Object?> get props => [text];
}

