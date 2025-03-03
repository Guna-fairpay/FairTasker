
import 'package:equatable/equatable.dart';

abstract class TextUploadState extends Equatable {
  const TextUploadState();
}

class TextUploadInitial extends TextUploadState {
  @override
  List<Object> get props => [];
}

class TextUploadLoading extends TextUploadState {
  @override
  List<Object> get props => [];
}

class TextUploadLoaded extends TextUploadState {
  final bool? message;
  const TextUploadLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}


