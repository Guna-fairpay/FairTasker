import 'package:equatable/equatable.dart';

abstract class TCCDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCCDInitialEvents extends TCCDEvents {
  final Map<String, dynamic>? model;
  TCCDInitialEvents(this.model);
  @override
  List<Object?> get props => [model];
}