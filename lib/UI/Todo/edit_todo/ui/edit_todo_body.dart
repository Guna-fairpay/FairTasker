
import 'dart:developer';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/task_add_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/resource_popup.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Component/custom_date_time_picker.dart';
import '../../../../Component/custom_multi_selection_chips_field.dart';
import '../bloc/edit_todo_bloc.dart';
import '../event/edit_todo_event.dart';
import '../state/edit_todo_state.dart';
import 'edit_todo_bottom_tabs.dart';
import 'edit_todo_more_form.dart';

class EditTodoBody extends StatelessWidget {
  const EditTodoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
        builder: (context, state) => Form(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDateTimePicker<DateTime>(
                      controller: context.read<EditToDoBloc>().dateController,
                      format: "dd-MM-yyyy",
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 18, color: context.theme.hintColor),
                      textAlign: TextAlign.center,
                      value: state.selectedDate,
                      onChanged: (value) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoDateChangeEvent(value)),
                    ),
                    CustomDateTimePicker<TimeOfDay>(
                      controller: context.read<EditToDoBloc>().timeController,
                      value: state.selectedTime,
                      use24HourFormat: true,
                      format: "HH:mm",
                      suffixIcon: Icon(Icons.access_time_rounded,
                          size: 18, color: context.theme.hintColor),
                      onChanged: (value) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoTimeChangeEvent(value)),
                    ),
                    GestureDetector(
                      onTap: () => context
                          .read<EditToDoBloc>()
                          .add(EditToDoTimeSensitiveEvent()),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 20,
                            child: Checkbox(
                              value: state.isTimeSensitive,
                              checkColor: AppC.white,
                              shape: ContinuousRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              side:
                                  const BorderSide(color: AppC.grey, width: 2),
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (states) =>
                                      (states.contains(WidgetState.selected))
                                          ? AppC.blue
                                          : AppC.white),
                              onChanged: (value) => context
                                  .read<EditToDoBloc>()
                                  .add(EditToDoTimeSensitiveEvent()),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.getText('Time', weight: FontWeight.bold),
                              Utils.getText('Sensitive',
                                  weight: FontWeight.bold),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        ResourceSelection.showResourceSelection(
                          context,
                          details,
                          state.resources,
                          state.selectedResource,
                          (value, name) => context.read<EditToDoBloc>().add(
                            UserSelectionEvent(
                                selectedResource: value,
                                resourceName: name
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Utils.getText(
                              state.resourceName.length > 1
                                  ? "${state.resourceName.first}..."
                                  : state.resourceName.join(', '),
                              weight: FontWeight.bold,
                              color: AppC.appColor),
                        ],
                      ),
                    ),
                    /*Expanded(
                      child: InkWell(
                        onTap: () =>
                            TaskerResourceDialog.show(
                            context,
                            state.resources,
                            state.selectedResource,
                                (value, name) => context.read<EditToDoBloc>().add(
                              UserSelectionEvent(
                                  selectedResource: value,
                                  resourceName: name),
                            ),
                          ),
                        child: Column(
                          children: [
                            Utils.getText(
                                state.resourceName.length > 1
                                    ? "${state.resourceName.first}..."
                                    : state.resourceName.join(', '),
                                weight: FontWeight.bold,
                                color: AppC.appColor),
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
                10.height,
                SearchViewField(
                    controller: context.read<EditToDoBloc>().taskNameController,
                    suggestions: state.tasks,
                    itemAsString: (item) => item['task'] ?? '',
                onSelected: (value) => context.read<EditToDoBloc>().add(EditToDoTaskEvent(selectedTask: value)),
                selectedItem: (state.selectedTask.isEmpty) ? null : state.selectedTask,
                onEmptyTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const TaskAddUI())),
                showEmpty: true,
                  labelText: 'Task Name',
                  hintText: "Select Task",
                ),
                10.height,
                CustomVehiclePersonField(
                  vehiclesList: state.vehicles,
                  personsList: state.persons,
                  groupVehicles: state.groupVehicles,
                  selected: state.selectedVPerson,
                 onDeleted: (val)=> context.read<EditToDoBloc>().add(EditToDoDeleteVehicleEvent(vehicleId: val?['value']?['vin'])),
                  onSelected: (val) => context
                      .read<EditToDoBloc>()
                      .add(EditToDoVPersonEvent(val)),
                  controller: context.read<EditToDoBloc>().vPersonController,

                ),
                10.height,
                CustomVendorLocationField(
                  vendorsList: state.vendors,
                  locationsList: state.locations,
                  selected: {3: state.selectedVLocations},
                  onSelected: (val) => context
                      .read<EditToDoBloc>()
                      .add(EditToDoVLocationEvent(val)),
                  controller: context.read<EditToDoBloc>().vLocationController,
                ),
                if (state.selectedVLocations['type'] == 'location')
                10.height,
                if (state.selectedVLocations['type'] == 'location')
                  CustomMultiSelectionChipsField<Map<String, dynamic>>(
                      selectedPartsList: state.addresses,
                      suggestionsList: state.selectedVLocations['addresses'] ?? [],
                      controller: TextEditingController(),
                      labelText: "Address",
                      onChanged: (isChecked, value) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoAddressSelectionEvent(value, isChecked)),
                      itemAsString: (item) => item['address'].toString()),
                10.height,
                Utils.getTextFormField(
                    'Notes', context.read<EditToDoBloc>().notesController,
                    isDense: true,
                    contentPadding: 10.padding,
                    labelStyle: context.textTheme.labelMedium
                        ?.copyWith(color: context.theme.hintColor),
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontFamily: "Lato"),
                    readOnly: false,
                    onChangeCallback: (value) {}),
                if(state.apiResponse['maintenance_task_id'] != null)
                10.height,
                if(state.apiResponse['maintenance_task_id'] != null)
                Utils.getTextFormField(
                    'Comments', context.read<EditToDoBloc>().commentsController,
                    isDense: true,
                    contentPadding: 10.padding,
                    labelStyle: context.textTheme.labelMedium
                        ?.copyWith(color: context.theme.hintColor),
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontFamily: "Lato"),
                    readOnly: false,
                    onChangeCallback: (value) {},
                  minLines: 3,
                  maxLines: 3,
                ),
                if(state.apiResponse['title'] == 'Fix')
                10.height,
                if(state.apiResponse['title'] == 'Fix')
                Utils.getTextFormField(
                    'Resolution Notes', context.read<EditToDoBloc>().resolutionNotesController,
                    isDense: true,
                    contentPadding: 10.padding,
                    labelStyle: context.textTheme.labelMedium
                        ?.copyWith(color: context.theme.hintColor),
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontFamily: "Lato"),
                    readOnly: false,
                    onChangeCallback: (value) {}),
                10.height,
                if (state.showPlatformCheck)
                  Utils.getCircleCheckWidget(
                      () => context
                          .read<EditToDoBloc>()
                          .add(EditToDoPlatformCheckEvent()),
                      state.isSelectedPlatformCheck,
                      'Platform Check'),
                10.height,
                const EditTodoMoreForm(),
                10.height,
                 if (state.apiResponse.isNotEmpty)
                  const EditTodoBottomTabs(),
              ],
            )));
  }
}
