part of '../Bloc/vendor_data_bloc.dart';

abstract class VendorDataEvent extends Equatable {
  const VendorDataEvent();
}

/*class GetAddedVendorListData extends VendorDataEvent {
  const GetAddedVendorListData();
  @override
  List<Object?> get props => [];
}*/

class AddVendorData extends VendorDataEvent {
  final String? name;
  final String? vendor_typeId;
  final String? address;
  final String? phone;
  final String? expertise;
  final String? description;
  final List<File> images;
  final int? id;
  const AddVendorData({
    required this.name,
    required this.vendor_typeId,
    required this.address,
    required this.phone,
    required this.expertise,
    required this.description,
    required this.images,
    required this.id});
  @override
  List<Object?> get props => [name,vendor_typeId, address,phone,expertise,description,images, id];
}

class GetVendorList extends VendorDataEvent {
  const GetVendorList();
  @override
  List<Object?> get props => [];
}

class DeleteVendorEvent extends VendorDataEvent {
  final int? id;
  const DeleteVendorEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetVendorTypeList extends VendorDataEvent {
  const GetVendorTypeList();
  @override
  List<Object?> get props => [];
}

class AddVendorType extends VendorDataEvent {
  final String? name;
  final int? id;
  const AddVendorType({
    required this.name,
    required this.id});
  @override
  List<Object?> get props => [name, id];
}

class DeleteVendorType extends VendorDataEvent {
  final int? id;
  const DeleteVendorType({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteImage extends VendorDataEvent {
  final int? id;
  const DeleteImage({required this.id});
  @override
  List<Object?> get props => [id];
}