
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/repository/parts_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event/parts_event.dart';
import '../state/parts_state.dart';

class PartsBloc extends Bloc<PartsEvent, PartsState> {
  final PartsRepository partsRepository=PartsRepository();

  PartsBloc() : super(PartsState(
  searchController: TextEditingController(),
  apiResponse: const [],
  filteredResponse: const [],
  isLoading: true,
    isAddPressed: false,
  )) {
    on<GetPartsDataList>((event, emit) async{
      emit(state.copyWith(isLoading: true));
      var response=await partsRepository.getPartsData();
      emit(state.copyWith(
          isLoading: false,
          apiResponse: response?.data,
          filteredResponse: response?.data,
      ));
    });
    on<SearchPartsEvent>((event, emit) {
      if (event.query == null || event.query!.isEmpty) {
        emit(state.copyWith(filteredResponse: state.apiResponse));
      } else {
        var filteredResponse = state.apiResponse.where((element) =>
            element['name'].toString().toLowerCase().contains(event.query!.toLowerCase())).toList();
        emit(state.copyWith(filteredResponse: filteredResponse));
      }
    });

    on<AddPartsEvent>((event, emit) async {
      // final newParts = await Navigator.push<Map<String, dynamic>>(
      //   context, MaterialPageRoute(builder: (context) => PartAddUI()),
      // );
      // if (newParts != null) {
      //     AddPartsEvent(
      //       newParts['id'],
      //       newParts['name'],
      //       newParts['note']
      //     );
      // }
      //     Utils.showMobileToast('Parts added successfully');
      emit(state.copyWith(isAddPressed: true));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isAddPressed: false));
    });

    }
}