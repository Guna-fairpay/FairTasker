part of '../ui/base_page_ui.dart';

abstract class BasePageEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class BasePageInitialEvent extends BasePageEvent{}

class BasePageTabEvent extends BasePageEvent{
  final int value;
  BasePageTabEvent(this.value);
  @override
  List<Object?> get props => [value];
}