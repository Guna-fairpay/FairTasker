import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_info_event.dart';
part 'booking_info_state.dart';

class BookingInfoBloc extends Bloc<BookingInfoEvent, BookingInfoState> {
  APiRepository _apiRepository = APiRepository();

  dynamic model;
  String? token;

  Future<Map<String, dynamic>?> getToken() async => await getIt<CommonService>().getRentalToken();
  Future<Map<String, dynamic>?> bookInfo({dynamic id, String? token}) async => await _apiRepository.getBookingInfo(id: id, token: token);

  BookingInfoBloc() : super(LoadingState()) {
    on<InitialEvent>((event, emit) async {
      try {
        emit(LoadingState());
        var response = await getToken();
        if(response != null){
          token = response['data'] ?? '';
          var bookingInfo = await bookInfo(token: token, id: event.model['rental_booking_id']);
          if(bookingInfo != null){
            model = bookingInfo['data'];
          }
        }
        emit(CommonState());
      } catch (e) {
        emit(ErrorState(e));
      }
    });
  }
}