
import 'package:fairpytasker/UI/Finance/Expense/Component/icon_with_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/task_details_view.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/expense_bloc.dart';
import '../State/expense_state.dart';

class TodoDetailsUI extends StatelessWidget {
  const TodoDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.getText("TODO DETAILS", weight: FontWeight.bold,size: 16,),
          10.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconAndText(
                icon: Icons.subtitles_sharp,
                label: "${state.todoDetails['title'] ?? ''}",
                labelColor: AppC.appColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsViewUI(
                todoDetails: state.todoDetails,
                expenseDetails: state.editResponse,
                userNames: state.userNames,
                vehicleNames: state.todoVehicles,
                categoryName: state.categoryName,
                subCategoryName: state.subCategoryName,
                  attachments: state.expenseAttachments,
              ),),
              ),),
              IconAndText(
                icon: Icons.date_range,
                label: "${state.todoDetails['todo_date'].toString().toDateTime().toFormat(format: "MM-dd-yyyy") ?? ''}  "
                    "${Utils.convertString24HTo12H("${state.todoDetails['todo_time'] ?? ''}")}"
              ),
              IconAndText(
                icon: Icons.person,
                label: state.userNames.join(','),
              ),
              IconAndText(
                icon: Icons.directions_car_filled,
                label: "${state.todoVehicles?.join(',')}",
              ),
              if (state.todoDetails['vendor_name'] != null)
                IconAndText(
                  icon: Icons.person_pin_outlined,
                  label: "${state.todoDetails['vendor_name'] ?? ''}",
                ),
              if (state.todoDetails['notes'] != null)
                IconAndText(
                  icon: Icons.speaker_notes,
                  label: "${state.todoDetails['notes'] ?? ''}",
                ),
            ],
          ),
        ],
      );
    });
  }
}
