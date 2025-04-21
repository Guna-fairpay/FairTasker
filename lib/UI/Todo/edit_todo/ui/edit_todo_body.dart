
import 'dart:developer';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/backup/task_add_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/Component/resource_popup.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //spacing: 5,
                  children: [
                    CustomDateTimePicker<DateTime>(
                      controller: context.read<EditToDoBloc>().dateController,
                      format: "MM-dd-yyyy",
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 15, color: context.theme.hintColor),
                      textAlign: TextAlign.center,
                      value: state.selectedDate,
                      onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoDateChangeEvent(value)),
                    ),
                    10.width,
                    CustomDateTimePicker<TimeOfDay>(
                      controller: context.read<EditToDoBloc>().timeController,
                      value: state.selectedTime,
                      use24HourFormat: true,
                      format: "HH:mm",
                      suffixIcon: Icon(Icons.access_time_rounded, size: 15, color: context.theme.hintColor),
                      onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoTimeChangeEvent(value)),
                    ),
                    Expanded(
                      child: CustomCheckboxListTile(
                        mainAxisSize: MainAxisSize.min,
                        useExpand: true,
                        title: Utils.getText('Time Sensitive', weight: FontWeight.bold,overFlow: TextOverflow.visible,size: 12.sp),
                        value: state.isTimeSensitive,
                        activeColor: AppC.grey,
                        onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoTimeSensitiveEvent()),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            ResourceSelection.showResourceSelection(
                              context,
                              details,
                              state.resources,
                              state.selectedResource,
                              (value, name) => context.read<EditToDoBloc>().add(
                                UserSelectionEvent(selectedResource: value, resourceName: name),
                              ),
                            );
                          },
                          child: Utils.getText(
                              state.resourceName.length > 1
                                  ? state.resourceName.join(',\n')
                                  : state.resourceName.join(', '),
                              weight: FontWeight.bold,
                              color: AppC.appColor),
                        ),
                      ],
                    ),
                  ],
                ),
                if(context.watch<EditToDoBloc>().reason != null)...[
                  Utils.getText("Reason : ${context.watch<EditToDoBloc>().reason ?? ''}",size: 10.sp,overFlow: TextOverflow.visible,color: AppC.grey),
                ],
                10.height,
                SearchViewField(
                  controller: context.read<EditToDoBloc>().taskNameController,
                  suggestions: state.tasks,
                  itemAsString: (item) => item['task'] ?? '',
                  onSelected: (value) => context.read<EditToDoBloc>().add(EditToDoTaskEvent(selectedTask: value)),
                  selectedItem: (state.selectedTask.isEmpty) ? null : state.selectedTask,
                  onEmptyTap: () => context.push(const TaskMainPage()),
                  showEmpty: true,
                  labelText: 'Task Name',
                  hintText: "Select Task",
                ),
                10.height,
                if(!["Check In", "Check Out"].contains(state.apiResponse['title']))
                  ...[
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

                    10.height,
                  ],
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
                if (state.showPlatformCheck ||Str.platFormCheckIds.contains(state.selectedTask['id']))
                  Utils.getCircleCheckWidget(() => context.read<EditToDoBloc>().add(EditToDoPlatformCheckEvent()),
                      state.isSelectedPlatformCheck,
                      'Platform Check'),
                10.height,
                if(!["Check In", "Check Out"].contains(state.apiResponse['title']))
                const EditTodoMoreForm(),
                10.height,
                 if (state.apiResponse.isNotEmpty)
                  const EditTodoBottomTabs(),
              ],
            )));
  }
}
