part of 'private_rental_customers_bloc.dart';

abstract class Event extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends Event {}
class PaginationEvent extends Event {
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}
class SearchEvent extends Event {
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}
class EditEvent extends Event {
  final dynamic model;
  EditEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class DeleteEvent extends Event {
  final dynamic model;
  final bool? proceed;
  DeleteEvent(this.model, {this.proceed});
  @override
  List<Object?> get props => [model, proceed];
}

class RentalDateEvent extends Event {
  final DateTime? date;
  RentalDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}
class PickLicenseEvent extends Event {}
class PickInsuranceEvent extends Event {}
class DeleteLicenseEvent extends Event {
  final dynamic model;
  final bool? proceed;
  DeleteLicenseEvent(this.model, {this.proceed});
  @override
  List<Object?> get props => [model, proceed];
}
class DeleteInsuranceEvent extends Event {
  final dynamic model;
  final bool? proceed;
  DeleteInsuranceEvent(this.model, {this.proceed});
  @override
  List<Object?> get props => [model, proceed];
}

class CancelEditEvent extends Event {}
class SubmitEvent extends Event {}