import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_task_identifier.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_more_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_recurring_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_recurring_sub_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_sub_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_task_manager_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoMainForm extends StatelessWidget {
  final bool showHeader;

  const AddTodoMainForm({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: !showHeader,
        padding: (showHeader) ? 10.topPadding : EdgeInsets.zero,
        physics: (showHeader)
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          const AddTodoSubForm(),
          10.height,
          const AddTodoMoreForm(),
          10.height,
          const AddTodoTaskManagerForm(),
          10.height,
          const AddTodoRecurringForm(),
          10.height,
          const AddTodoRecurringSubForm(),
          16.height,
          BlocSelector<AddToDoBloc, AddToDoState, AddToDoState>(
              selector: (state) => state,
              builder: (context, state) => ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(AppC.buttonColor),
                      textStyle: WidgetStatePropertyAll(context
                          .textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                      foregroundColor: const WidgetStatePropertyAll(AppC.white),
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Num.borderRadiusLarge)))),
                  onPressed: () =>
                      context.read<AddToDoBloc>().add(AddToDoSaveEvent()),
                  child: const Text("Save"))),
          16.height,
          BlocSelector<AddToDoBloc, AddToDoState, Map?>(
            selector: (state) => state.selectedVPerson
                .where((element) =>
                    ["vehicles", "g_vehicles"].contains(element['type']))
                .lastOrNull,
            builder: (context, state) => ((state != null) &&
                    (state.isNotEmpty ?? false))
                ? SizedBox(
              // height: context.height * 0.7,
                  child: VehicleHistoryViewUI(
                    additionalScroll: false,
                      vin: ((state['type'] == "vehicles")
                          ? (state['value']?['vin'])
                          : null),
                      vehicleName: state['name'],
                      groupId:
                          (state['type'] == "g_vehicles") ? state['id'] : null,
                      showHeader: false),
                )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
