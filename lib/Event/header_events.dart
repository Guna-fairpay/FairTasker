import 'package:equatable/equatable.dart';

abstract class HeaderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HeaderInitialEvent extends HeaderEvent {}
class EmailRefreshEvent extends HeaderEvent {}
class ManualCountUpdateEvent extends HeaderEvent {
  final dynamic count;
  ManualCountUpdateEvent(this.count);
  @override
  List<Object?> get props => [count];
}