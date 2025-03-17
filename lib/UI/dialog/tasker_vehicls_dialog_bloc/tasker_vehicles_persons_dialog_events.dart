import 'package:equatable/equatable.dart';

abstract class TVPDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVPDInitialEvent extends TVPDEvents {
  final Map<String, dynamic>? data;
  TVPDInitialEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class TVPDSelectedEvent extends TVPDEvents {
  final List<Map<String, dynamic>>? data;
  TVPDSelectedEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class TVPDDeleteEvent extends TVPDEvents {
  final Map<String, dynamic>? data;
  TVPDDeleteEvent({required this.data});
  @override
  List<Object?> get props => [data];
}