import 'package:equatable/equatable.dart';

import '../Response/text_upload_response.dart';

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
  final bool? result;
  const TextUploadLoaded({required this.result});

  @override
  List<Object?> get props => [result];
}


class TextUploadListLoaded extends TextUploadState {
  final List<UploadTextData>? resource;
  const TextUploadListLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}
