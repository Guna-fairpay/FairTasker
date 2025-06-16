part of 'vendor_bloc.dart';

abstract class VendorEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VendorEvent {}

class VendorTypeEvent extends VendorEvent {}

class AddressEvent extends VendorEvent {}

class PickImageEvent extends VendorEvent {}

class RemoveImageEvent extends VendorEvent {}