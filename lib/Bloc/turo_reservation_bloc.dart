
import 'package:bloc/bloc.dart';
import '../Event/turo_reservation_event.dart';
import '../Repository/turo_reservation_repository.dart';
import '../State/turo_reservation_state.dart';


class TuroReservationBloc extends Bloc<TuroReservationEvent, TuroReservationState> {
  TuroReservationBloc() : super(TuroReservationInitial()) {
    TuroReservationRepository turoReservationRepository = TuroReservationRepository();

    on<AddTuroReservationData>((event, emit) async {
      emit(TuroReservationLoading());
      await turoReservationRepository.uploadTuroReservation(
        event.id,
        event.data,
      )
          .then((value) {
        if (value != null) {
          emit(TuroReservationLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
