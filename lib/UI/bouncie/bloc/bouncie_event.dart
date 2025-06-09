part of 'bouncie_bloc.dart';

abstract class BouncieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends BouncieEvent {}
class ViewBouncieEvent extends BouncieEvent {
  final dynamic model;
  ViewBouncieEvent(this.model);
  @override
  List<Object?> get props => [model];
}