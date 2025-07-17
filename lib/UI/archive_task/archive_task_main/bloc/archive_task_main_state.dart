part of 'archive_task_main_bloc.dart';

abstract class ArchiveTaskMainState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommonState extends ArchiveTaskMainState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}