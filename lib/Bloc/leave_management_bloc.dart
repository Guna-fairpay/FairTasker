
import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Event/leave_management_event.dart';
import 'package:fairpytasker/Repository/leave_management_repository.dart';
import 'package:fairpytasker/State/leave_management_state.dart';


class LeaveManagementBloc extends Bloc<LeaveManagementEvent, LeaveManagementState> {
  LeaveManagementBloc() : super(LeaveManagementInitial()) {
    LeaveManagementRepository leaveManagementRepository = LeaveManagementRepository();

    on<GetLeaveManagementData>((event, emit) async {
      emit(LeaveManagementLoading());

      await leaveManagementRepository.getLeaveList()
          .then((value) {
        if (value != null) {
          emit(LeaveManagementListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddLeaveManagementData>((event, emit) async {
      emit(LeaveManagementLoading());

      await leaveManagementRepository.createLeaveList(
          event.id,
          event.userId,
          event.leaveTypeId,
          event.startDate,
          event. endDate,
          event.reason,
          event.startTime,
          event.endTime,
          event.status)
          .then((value) {
        if (value != null) {
          emit(LeaveManagementLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteLeaveManagement>((event, emit) async {
      emit(LeaveManagementLoading());

      await leaveManagementRepository.deleteDepartment(event.id)
          .then((value) {
        if (value != null) {
          emit(LeaveManagementLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<GetLeaveManagementEmployeeListData>((event, emit) async {
      emit(LeaveManagementLoading());

      await leaveManagementRepository.getEmployeeList()
          .then((value) {
        if (value != null) {
          emit(LeaveManagementEmployeeListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetLeaveTypeListData>((event, emit) async {
      emit(LeaveManagementLoading());

      await leaveManagementRepository.getLeaveTypeList()
          .then((value) {
        if (value != null) {
          emit(LeaveTypeListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

  }
}
