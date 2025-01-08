
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Repository/vendor_repository.dart';
part '../Event/vendor_data_event.dart';
part '../State/vendor_data_state.dart';

class VendorDataBloc extends Bloc<VendorDataEvent, VendorDataState> {
  VendorDataRepo vendorDataRepo = VendorDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();

  VendorDataBloc() : super(VendorDataInitial()) {
    on<VendorDataEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddVendorData>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.createVendor(
          event.id,
          event.name??'',
          event.vendor_typeId??'',
          event.address??'',
          event.phone??'',
          event.expertise??'',
          event.description??'',
          event.images.cast<File>(),
      ).then((value) {
        emit(VendorDataLoaded(result: value));
      });
    });

    on<GetVendorList>((event, emit) async {
      emit(const VendorDataLoading());
      await todoListRepo
          .getVendor()
          .then((value) {
        emit(VendorListLoaded(resource: value?.data??[]));
      });
    });

    on<DeleteVendorEvent>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteVendor(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value));
      });
    });

    on<GetVendorTypeList>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .getVendorType()
          .then((value) {
        emit(VendorTypeListLoaded(resource: value?.data??[]));
      });
    });

    on<AddVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.createVendorType(
        event.id,
        event.name??'',
      ).then((value) {
        emit(VendorDataLoaded(result: value));
      });
    });

    on<DeleteVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteVendorType(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value));
      });
    });

    on<DeleteImage>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteImages(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value));
      });
    });

  }
}
