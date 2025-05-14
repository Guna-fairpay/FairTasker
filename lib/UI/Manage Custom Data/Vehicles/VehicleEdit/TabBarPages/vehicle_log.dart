import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/vehicle_log_listing_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/vehicle_log_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_states.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/expense_log_attachment_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VehicleLogUI extends StatelessWidget {
  final dynamic vin;
  const VehicleLogUI({super.key,required this.vin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => VehicleLogBloc()..add(VehicleLogInitialEvent(vin)),
        child: BlocListener<VehicleLogBloc, VehicleLogState>(
          listener: (context, state) {
            if (state is VehicleLogLoadingState) {
             if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state) {
                case VehicleLogErrorState(): Toaster.showError(state.message); break;
                case VehicleLogSuccessState(): Toaster.showSuccess(state.message); break;
                case VehicleLogDeleteTapState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this vehicle log?", negativeText: "No", positiveText: "Yes", isReasonRequired: false, onPositivePressed: () => context.read<VehicleLogBloc>().add(VehicleLogDeleteEvent(state.model))); break;
                case VehicleLogViewAttachmentState(): ExpenseLogAttachmentDialog.show(context, model: state.model); break;
                case VehicleLogNotesTapState(): NotesDialog.show(context, message: (state.model?['notes'] ?? ""), barrierDismissible: false, onSave: (value) => context.read<VehicleLogBloc>().add(VehicleLogNotesUpdateEvent(state.model, value))); break;
              }
            }
          },
          child: SafeArea(
              child: Column(
                spacing: 10,
            children: [
              AddVehicleLogView(vin: vin, searchChild: const VehicleLogSearchView()),
              const VehicleLogListingView(),
            ],
          )),
        ));
  }
}
