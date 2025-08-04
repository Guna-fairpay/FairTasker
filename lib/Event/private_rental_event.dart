import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PrivateRentalEvent extends Equatable {
  const PrivateRentalEvent();
}

class PrivateRentalInitialEvent extends PrivateRentalEvent {
  @override
  List<Object?> get props => [];
}

class GetPrivateRentalData extends PrivateRentalEvent {
  const GetPrivateRentalData();
  @override
  List<Object?> get props => [];
}

class AddPrivateRentalData extends PrivateRentalEvent {
  final String vin;
  final String customerId;
  final String checkInDate;
  final String checkOutDate;
  final String? checkInMileage;
  final String? checkOutMileage;
  final String? rentalStatus;
  final int? id;

  const AddPrivateRentalData({
    required this.vin,
    required this.customerId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInMileage,
    required this.checkOutMileage,
    required this.rentalStatus,
    required this.id,
  });
  @override
  List<Object?> get props => [
        vin,
        customerId,
        checkInDate,
        checkOutDate,
        checkInMileage,
        checkOutMileage,
        rentalStatus,
        id
      ];
}

class DeletePrivateRentalData extends PrivateRentalEvent {
  final String id;
  const DeletePrivateRentalData({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class GetCustomerData extends PrivateRentalEvent {
  const GetCustomerData();
  @override
  List<Object?> get props => [];
}

class GetEditCustomerData extends PrivateRentalEvent {
  final int? id;
  const GetEditCustomerData({required this.id});
  @override
  List<Object?> get props => [id];
}

class AddCustomerData extends PrivateRentalEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String monthlyRental;
  final String rentalStartDate;
  final String securityDeposit;
  final String note;
   final List<File> licenceAttach;
   final List<File> insuranceAttach;
  final int? id;

  const AddCustomerData({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.monthlyRental,
    required this.rentalStartDate,
    required this.securityDeposit,
    required this.note,
     required this.insuranceAttach,
    required this.licenceAttach,
    required this.id,
  });
  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phone,
        address,
        monthlyRental,
        rentalStartDate,
        securityDeposit,
        note,
        // insuranceAttach,
        // licenceAttach,
        id,
      ];
}

class DeleteCustomer extends PrivateRentalEvent {
  final int id;
  const DeleteCustomer({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}
