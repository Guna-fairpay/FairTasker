part of '../Bloc/vendor_data_bloc.dart';

abstract class VendorDataState extends Equatable {
  const VendorDataState();
}

class VendorDataInitial extends VendorDataState {
  @override
  List<Object> get props => [];
}

class VendorDataLoaded extends VendorDataState {
  final String? result;
  const VendorDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VendorDataLoading extends VendorDataState {
  const VendorDataLoading();
  @override
  List<Object?> get props => [];
}

class VendorListLoaded extends VendorDataState {
  final List<Map<String, dynamic>>? resource;
  const VendorListLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class VendorTypeListLoaded extends VendorDataState {
  final List<Map<String,dynamic>>? resource;
  final List<Map<String,dynamic>>? vendorTypeData;
  const VendorTypeListLoaded({required this.resource, this.vendorTypeData});
  @override
  List<Object?> get props => [resource, vendorTypeData];
}

class VendorDataCommonState extends VendorDataState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}





