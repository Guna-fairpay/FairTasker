
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/location_repository.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';

part '../Event/location_data_event.dart';
part '../State/location_data_state.dart';

class LocationDataBloc extends Bloc<LocationDataEvent, LocationDataState> {
  LocationDataRepo locationDataRepo = LocationDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();

  LocationDataBloc() : super(LocationDataInitial()) {
    on<LocationDataEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetAddedLocationListData>((event, emit) async {
      emit(const LocationDataLoading());
      await todoListRepo
          .getLocation()
          .then((value) {
        emit(LocationListLoaded(resource: value?.data??[]));
      });
    });

    on<AddLocationData>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.createLocation(
         id:  event.id,
         name:  event.name,
          address: event.address).then((value) {
        emit(LocationDataLoaded(message:event.id==null?'Location Added Successfully':'Location Updated Successfully', ));
      });
    });

    on<DeleteLocationEvent>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.deleteLocation(event.id).then((value) {
        emit(LocationDataLoaded(message: 'Location Added Successfully'));
      });
    });

    on<DeleteLocation>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.delete(event.id).then((value) {
        emit(LocationDataLoaded(message: 'test1 deleted successfully'));
      });
    });

  }
}

