import 'package:equatable/equatable.dart';

abstract class TOCDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TOCDInitialEvents extends TOCDEvents {
  final Map<String, dynamic>? model;
  TOCDInitialEvents(this.model);
  @override
  List<Object?> get props => [model];
}

class TOCDSubmitEvent extends TOCDEvents {
  final bool isOverride;
  TOCDSubmitEvent({this.isOverride = false});
  @override
  List<Object?> get props => [isOverride];
}