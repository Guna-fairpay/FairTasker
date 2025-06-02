part of 'other_view_bloc.dart';

abstract class OtherViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends OtherViewEvent{}

class DateRangeEvent extends OtherViewEvent{
  final DateRange dateRange;
  DateRangeEvent(this.dateRange);
  @override
  List<Object?> get props => [dateRange];
}

