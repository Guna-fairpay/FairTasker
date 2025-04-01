
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
         id : event.id,
         name : event.name ??'',
         vendorTypeId : event.vendorTypeId ??'',
         address : event.address ??'',
         phone : event.phone ??'',
         expertise : event.expertise ??'',
         description : event.description ??'',
         images : event.images,
      ).then((value) {
        emit(VendorDataLoaded(result: value.toString()));
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
        emit(VendorDataLoaded(result: value.toString()));
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
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<DeleteVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteVendorType(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<DeleteImage>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteImages(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

  }
}
