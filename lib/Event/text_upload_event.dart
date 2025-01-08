
import 'package:equatable/equatable.dart';

abstract class TextUploadEvent extends Equatable {
  const TextUploadEvent();
}

class GetTextUploadEvent extends TextUploadEvent {
  const GetTextUploadEvent();

  @override
  List<Object> get props => [];
}

class CreateTextUpload extends TextUploadEvent {
  final String text;
  final int? id;

  const CreateTextUpload({required this.text,required this.id});

  @override
  List<Object?> get props => [text, id];
}

class DeleteTextUploadEvent extends TextUploadEvent {
  final int id;

  const DeleteTextUploadEvent({required this.id});

  @override
  List<Object> get props => [id];
}
