import 'package:equatable/equatable.dart';

abstract class PrivateRentalState extends Equatable {
  const PrivateRentalState();

  @override
  List<Object?> get props => [];
}

class PrivateRentalInitial extends PrivateRentalState {
  @override
  List<Object> get props => [];
}

class PrivateRentalLoading extends PrivateRentalState {}

class PrivateRentalLoaded extends PrivateRentalState {
  final List<Map<String, dynamic>>? data;
  const PrivateRentalLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class PrivateRentalListLoaded extends PrivateRentalState {
  final String? message;
  const PrivateRentalListLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}

class PrivateRentalError extends PrivateRentalState {
  final String message;
  const PrivateRentalError(this.message);
  @override
  List<Object> get props => [message];
}

class CustomerLoaded extends PrivateRentalState {
  final List<Map<String, dynamic>>? data;
  const CustomerLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditCustomerLoaded extends PrivateRentalState {
  final Map<String, dynamic>? data;
  const EditCustomerLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class CustomerListLoaded extends PrivateRentalState {
  final String? message;
  const CustomerListLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}
