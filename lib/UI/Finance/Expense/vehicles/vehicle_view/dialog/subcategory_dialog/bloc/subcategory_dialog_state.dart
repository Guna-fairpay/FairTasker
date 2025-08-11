part of 'subcategory_dialog_bloc.dart';

abstract class SubcategoryDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends SubcategoryDialogState{}

class ErrorState extends SubcategoryDialogState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends SubcategoryDialogState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class CommonState extends SubcategoryDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

