import 'package:equatable/equatable.dart';

abstract class HeaderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HeaderInitialEvent extends HeaderEvent {}
class EmailRefreshEvent extends HeaderEvent {}