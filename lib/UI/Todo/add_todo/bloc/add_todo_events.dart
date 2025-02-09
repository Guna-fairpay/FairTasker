import 'package:equatable/equatable.dart';

abstract class AddToDoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToDoInitialEvent extends AddToDoEvent {
  final bool showAppBar;

  AddToDoInitialEvent(this.showAppBar);

  @override
  List<Object?> get props => [showAppBar];
}
