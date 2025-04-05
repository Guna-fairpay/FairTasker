import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_notes_page/Bloc/vehicle_notes_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_notes_page/Bloc/vehicle_notes_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_notes_page/Bloc/vehicle_notes_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleNotesListing extends StatelessWidget {
  const VehicleNotesListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleNotesBloc, VehicleNotesState>(
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: context.watch<VehicleNotesBloc>().notesData.length,
        itemBuilder: (context, index) {
          final notes = context.watch<VehicleNotesBloc>().notesData[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppC.appColor,
                ),
                child: Center(
                  child: Utils.getText(
                    <String>[
                      (notes['user']?['first_name'] ?? ""),
                      (notes['user']?['last_name'] ?? "")
                    ].toInitial,
                    weight: FontWeight.bold,
                    color: AppC.white,
                  ),
                ),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.getText(
                      notes['created_at'] != null
                          ? DateFormat('MM-dd-yy').format(DateTime.parse(notes['created_at']))
                          : '',
                    ),
                    10.height,
                    Utils.getText(
                      notes['note'] ?? '',
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: AppC.appColor,
                        onPressed: () => context.read<VehicleNotesBloc>().add(UpdateNotesIsPressedEvent(editData: notes)),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        color: AppC.redAccent,
                        onPressed: () {
                          AskPermissionDialog.show(context,
                              title: "Are you sure?",
                              description: "Do you want to delete this notes?",
                              positiveText: "Yes!",
                              negativeText: "Cancel",
                              isReasonRequired: false,
                              onPositivePressed: () => context.read<VehicleNotesBloc>().add(DeleteNotesEvent(id: notes['id'].toString()),));
                        },
                        icon: const Icon(Icons.delete_outline_sharp),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Utils.getText(
                      notes['followup_date'] != null
                          ? DateFormat('MM-dd-yy').format(DateTime.parse(notes['followup_date']))
                          : '',
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
