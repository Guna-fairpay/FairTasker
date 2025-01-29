import 'package:equatable/equatable.dart';

abstract class PartsEvent extends Equatable{
  const PartsEvent();
  @override
  List<Object?> get props => [];
}

class GetPartsDataList extends PartsEvent{
  const GetPartsDataList();
  @override
  List<Object?> get props => [];
}

class SearchPartsEvent extends PartsEvent {
  final String? query;
  const SearchPartsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class AddPartsEvent extends PartsEvent {
  final String? name;
  final String? desc;
  final int? id;
  const AddPartsEvent( this.name, this.desc, this.id,);
  @override
  List<Object?> get props => [name, desc, id];

}