part of 'archive_task_main_bloc.dart';

abstract class ArchiveTaskMainEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ArchiveTaskMainEvent{}

class TabEvent extends ArchiveTaskMainEvent{
  final int value;
  TabEvent(this.value);
  @override
  List<Object?> get props => [value];
}