
import 'package:bloc/bloc.dart';

import '../Event/category_config_event.dart';
import '../Repository/category_config_repository.dart';
import '../State/category_config_state.dart';




class CategoryConfigBloc extends Bloc<CategoryConfigEvent, CategoryConfigState> {
  CategoryConfigBloc() : super(CategoryConfigInitial()) {
    CategoryConfigRepository categoryConfigRepository = CategoryConfigRepository();

    on<GetCategoryConfigData>((event, emit) async {
      emit(CategoryConfigLoading());

      await categoryConfigRepository.getCategoryConfig()
          .then((value) {
        if (value != null) {
          emit(CategoryConfigListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddCategoryConfigData>((event, emit) async {
      emit(CategoryConfigLoading());

      await categoryConfigRepository.createCategoryConfig(event.id,event.name,event.userType,event.parentId)
          .then((value) {
        if (value != null) {
          emit(CategoryConfigLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteCategoryConfig>((event, emit) async {
      emit(CategoryConfigLoading());

      await categoryConfigRepository.deleteCategoryConfig(event.id)
          .then((value) {
        if (value != null) {
          emit(CategoryConfigLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
