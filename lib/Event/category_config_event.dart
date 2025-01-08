
import 'package:equatable/equatable.dart';

abstract class CategoryConfigEvent extends Equatable {
  const CategoryConfigEvent();
}

class CategoryConfigInitialEvent extends CategoryConfigEvent {
  @override
  List<Object?> get props => [];
}

class GetCategoryConfigData extends CategoryConfigEvent {
  const GetCategoryConfigData();
  @override
  List<Object> get props => [];
}

class AddCategoryConfigData extends CategoryConfigEvent {

  final String name;
  final String userType;
  final String parentId;
  final int? id;

  const AddCategoryConfigData({
    required this.name,required this.userType,required this.parentId, required this.id,
  });
  @override
  List<Object?> get props => [name,userType,parentId,id];
}

class DeleteCategoryConfig extends CategoryConfigEvent {
  final String id;

  const DeleteCategoryConfig({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
