part of '../Bloc/vendor_data_bloc.dart';

abstract class VendorDataEvent extends Equatable {
  const VendorDataEvent();
  @override
  List<Object?> get props => [];
}

/*class GetAddedVendorListData extends VendorDataEvent {
  const GetAddedVendorListData();
  @override
  List<Object?> get props => [];
}*/

class AddVendorData extends VendorDataEvent {
  final String? name;
  final int? vendorTypeId;
  final String? address;
  final String? phone;
  final String? expertise;
  final String? description;
  final String? latitude;
  final String? longitude;
  final String? website;
  final List<File>? images;
  final int? id;
  const AddVendorData({
    required this.name,
    required this.vendorTypeId,
    required this.address,
    required this.phone,
    required this.expertise,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.images,
    required this.id});
  @override
  List<Object?> get props => [
    name,
    vendorTypeId,
    address,
    phone,
    expertise,
    description,
    latitude,
    longitude,
    website,
    images,
    id
  ];
}

class EnterEditModeEvent extends VendorDataEvent {
  dynamic vendor;
  EnterEditModeEvent( {required this.vendor});
  @override
  List<Object?> get props => [ vendor];
}

class locationEvent extends VendorDataEvent {
  dynamic latitude;
  dynamic longitude;
  locationEvent( {required this.latitude, required this.longitude});
  @override
  List<Object?> get props => [ latitude, longitude];
}

class EnterVendorTypeEditEvent extends VendorDataEvent {
  dynamic vendor;
  EnterVendorTypeEditEvent( {required this.vendor});
  @override
  List<Object?> get props => [ vendor];
}

class ExitEditModeEvent extends VendorDataEvent {}
class ExitVendorTypeEditEvent extends VendorDataEvent {}

class VendorInitialEvent extends VendorDataEvent {
  final String? title;
  const VendorInitialEvent({this.title});
  @override
  List<Object?> get props => [title];
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
  final dynamic id;
  const DeleteImage({required this.id});
  @override
  List<Object?> get props => [id];
}
//vendor view search 2
class FilterVendorsEvent extends VendorDataEvent {
  final String searchTerm;
  const FilterVendorsEvent({required this.searchTerm});
}

class FilterVendorTypeEvent extends VendorDataEvent {
  final String searchTerm;
  const FilterVendorTypeEvent({required this.searchTerm});
}

class FilterVendorEvent extends VendorDataEvent {
  final String searchTerm;
  const FilterVendorEvent({required this.searchTerm});
}


class VendorPaginationEvent extends VendorDataEvent {
  final int page;
  VendorPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class VendorTypePaginationEvent extends VendorDataEvent {
  final int page;
  VendorTypePaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class VendorImageEvent extends VendorDataEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveVendorImageEvent extends VendorDataEvent {
  final int index;
  const RemoveVendorImageEvent({required this.index});
}

class ResetLocationEvent extends VendorDataEvent {
  const ResetLocationEvent();
  @override
  List<Object?> get props => [];
}
