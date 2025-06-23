
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/Bloc/vehicle_notes_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/Bloc/vehicle_notes_state.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/Bloc/vehicle_notes_event.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class VehicleNotesAdd extends StatelessWidget {
  final String? vin;
  const VehicleNotesAdd({super.key,required this.vin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleNotesBloc, VehicleNotesState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.getTextFormField(
            'Notes',
            context.read<VehicleNotesBloc>().notesController,
            minLines: 7,
            maxLines: 10,
            ),
          10.height,
          CustomDateTimePicker<DateTime>(
            controller:
            context.read<VehicleNotesBloc>().dateController,
            format: "MM-dd-yyyy",
            suffixIcon: Icon(Icons.calendar_month_rounded,
                size: 18, color: context.theme.hintColor),
            value: context.watch<VehicleNotesBloc>().selectedDate,
            showAsExpanded: true,
            labelText: 'Select followup date',
            onChanged: (value) => context
                .read<VehicleNotesBloc>()
                .add(DatePickEvent(selectedDate: value)),
          ),
          10.height,
          Row(
            spacing: 10,
            children: [
              if(!context.read<VehicleNotesBloc>().isEdit)
              Utils.getElevatedButton(
                      ()=>context.read<VehicleNotesBloc>().add(SaveNotesEvent(vin: vin)),
                  bgColor: AppC.appColor),
              if(context.read<VehicleNotesBloc>().isEdit)
              Utils.getElevatedButton(
                      ()=>context.read<VehicleNotesBloc>().add(UpdateNotesEvent()),
                  bgColor: AppC.green,
                text: 'Update',
              ),
              if(context.read<VehicleNotesBloc>().isEdit)
              Utils.getElevatedButton(
                      ()=>context.read<VehicleNotesBloc>().add(UpdateNotesIsCancelledEvent()),
                  bgColor: AppC.redAccent,
                text: 'Cancel',
              ),
            ],
          ),
          10.height,
        ],
      ),
    );
  }
}
