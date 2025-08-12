part of 'category_change_dialog_bloc.dart';

abstract class CategoryDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CategoryDialogState{}

class ErrorState extends CategoryDialogState{
  final String message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends CategoryDialogState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class CommonState extends CategoryDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SubcategoryState extends CategoryDialogState{
  final dynamic data;
  SubcategoryState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}