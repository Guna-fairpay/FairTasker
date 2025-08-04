part of '../ui/base_page_ui.dart';

abstract class BasePageState extends Equatable{
  @override
  List<Object?> get props => [];
}

class BasePageCommentState extends BasePageState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}