

import 'package:bloc/bloc.dart';

import '../Event/private_rental_event.dart';
import '../Repository/private_rental_repository.dart';
import '../State/private_rental_state.dart';



class PrivateRentalBloc extends Bloc<PrivateRentalEvent, PrivateRentalState> {
  PrivateRentalBloc() : super(PrivateRentalInitial()) {
    PrivateRentalRepository privateRentalRepository = PrivateRentalRepository();

    on<GetPrivateRentalData>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.getPrivateRentalData().then((value) {
        emit(PrivateRentalLoaded(data: value?.data??[]));
      });
    });

    on<AddPrivateRentalData>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.createPrivateRental(
        event.id,
        event.vin,
        event.customerId,
        event.checkInDate,
        event.checkOutDate,
        event.checkInMileage,
        event.checkOutMileage,
        event.rentalStatus,
      ).then((value) {
        emit(PrivateRentalListLoaded(message: value?.message));
      });
    });

    on<GetCustomerData>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.getCustomerData().then((value) {
        emit(CustomerLoaded(data: value?.data??[]));
      });
    });

    on<GetEditCustomerData>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.getEditCustomerData(event.id).then((value) {
        emit(EditCustomerLoaded(data:value?.editData));
      });
    });

    on<AddCustomerData>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.createCustomer(
        event.id,
        event.firstName,
        event.lastName,
        event.phone,
        event.address,
        event.monthlyRental,
        event.rentalStartDate,
        event.securityDeposit,
        event.note,
        event.licenceAttach,
        event.insuranceAttach,
      ).then((value) {
        emit(CustomerListLoaded(message:value.toString(),));
      });
    });

    on<DeleteCustomer>((event, emit) async {
      emit(PrivateRentalLoading());
      await privateRentalRepository.deleteCustomer(event.id)
          .then((value) {
        if (value != null) {
          emit(CustomerListLoaded(
            message: value.toString(),
          ));
        }
      });
    });

  }
}
