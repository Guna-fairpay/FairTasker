// import 'package:bloc/bloc.dart';
// import 'package:fairpytasker/Event/cohorts_event.dart';
// import '../Repository/cohorts_repository.dart';
// import '../State/cohorts_state.dart';
//
// class CohortsBloc extends Bloc<CohortsEvent, CohortsState> {
//   CohortsBloc() : super(CohortsInitial()) {
//     CohortsRepository cohortsRepository = CohortsRepository();
//
//     // Event handler for GetCohortsData
//     on<GetCohortsData>((event, emit) async {
//       emit(CohortsLoading());
//
//       await cohortsRepository.getCohorts().then((value) {
//         if (value != null) {
//           emit(CohortsListLoaded(
//             cohortData: value.cohortData ?? [],
//             expenseData: value.expenseData ?? [],
//           ));
//         }
//       });
//     });
//
//     on<GetPaymentData>((event, emit) async {
//       emit(CohortsLoading());
//       await cohortsRepository.getPayment().then((value) {
//         if (value != null) {
//           emit(PaymentListLoaded(
//             data: value.data ?? [],
//           ));
//         }
//       });
//     });
//   }
// }
