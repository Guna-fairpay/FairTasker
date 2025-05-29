part of 'base_page_bloc.dart';

abstract class BasePageState extends Equatable{
  @override
  List<Object?> get props => [];
}

class BasePageCommentState extends BasePageState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}