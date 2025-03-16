import 'package:equatable/equatable.dart';

abstract class TVSEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVSInitialEvent extends TVSEvents {}
class TVSSelectedEvent extends TVSEvents {
  final Map<String, dynamic>? model;
  TVSSelectedEvent({required this.model});
  @override
  List<Object?> get props => [model];
}
class TVSSelectPageEvent extends TVSEvents {
  final int page;
  TVSSelectPageEvent({required this.page});
  @override
  List<Object?> get props => [page];
}