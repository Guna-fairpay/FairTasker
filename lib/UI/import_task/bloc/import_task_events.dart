import 'package:equatable/equatable.dart';

abstract class ImportTaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImportTaskInitialEvent extends ImportTaskEvent {
  final int? fixedPageIndex;
  ImportTaskInitialEvent({this.fixedPageIndex});
  @override
  List<Object?> get props => [fixedPageIndex];
}

class ImportTaskPageEvent extends ImportTaskEvent {
  final int pageIndex;
  ImportTaskPageEvent(this.pageIndex);
  @override
  List<Object?> get props => [pageIndex];
}

class ImportTaskSaveEvent extends ImportTaskEvent {}