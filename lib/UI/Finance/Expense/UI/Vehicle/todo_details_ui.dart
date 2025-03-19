
import 'package:fairpytasker/Component/custom_vehicle_expense_history_Info.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/expense_bloc.dart';
import '../../State/expense_state.dart';

class TodoDetailsUI extends StatelessWidget {
  const TodoDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context,state) {
            Color iconColor = Colors.black87;
            Color textColor = AppC.text;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText("TODO DETAILS",weight: FontWeight.bold),
                10.height,
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                        color: Colors.blueAccent.shade100, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoWidget(
                        icon: Icons.subtitles_sharp,
                        label: 'Title',
                        value: "${state.todoDetails['title'] ?? ''}",
                        iconColor: iconColor,

                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                      InfoWidget(
                        icon: Icons.date_range,
                        label: 'Date & Time',
                        value:
                        "${state.todoDetails['todo_date'] ?? ''}  "
                            "${state.todoDetails['todo_time'] ?? ''}",
                        iconColor: iconColor,
                        textColor: textColor,
                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                      InfoWidget(
                        icon: Icons.person,
                        label: 'Resource',
                        value: state.userNames.join(','),
                        iconColor: iconColor,
                        textColor: textColor,
                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                      InfoWidget(
                        icon: Icons.directions_car_filled,
                        label: 'Vehicle Name',
                        value: "${state.todoVehicles?.join(',')}",
                        iconColor: iconColor,
                        textColor: textColor,
                      ),
                      if(state.todoDetails['vendor_name'] != null)
                      const Divider(thickness: 0.5, color: Colors.grey),
                      if(state.todoDetails['vendor_name'] != null)
                      InfoWidget(
                        icon: Icons.person_pin_outlined,
                        label: 'Vendor',
                        value: "${state.todoDetails['vendor_name'] ?? ''}",
                        iconColor: iconColor,
                        textColor: textColor,
                      ),
                      if(state.todoDetails['vendor_name'] != null)
                      const Divider(thickness: 0.5, color: Colors.grey),
                      if(state.todoDetails['notes'] != null)
                       InfoWidget(
                        icon: Icons.speaker_notes,
                        label: 'Notes',
                        value: "${state.todoDetails['notes'] ?? ''}",
                         iconColor: iconColor,
                         textColor: textColor,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        );
  }
}
