import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/resource_popup.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Component/custom_date_time_picker.dart';
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
                  spacing: 5,
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
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          ResourceSelection.showResourceSelection(
                            context,
                            details,
                            state.resources,
                            state.selectedResource,
                            (value) => context.read<EditToDoBloc>().add(
                                UserSelectionEvent(selectedResource: value)),

                          );
                        },
                        child: Column(
                          children: [
                            Utils.getText(
                                state.resourceName.length > 1
                                    ? "${state.resourceName.first}..."
                                    : state.resourceName.join(', '),
                                weight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                10.height,
                Utils.getTextFormField(
                  'Task Name',
                  context.read<EditToDoBloc>().taskNameController,
                  isDense: true,
                  showErrorSuffix: true,
                  borderRadius: Num.borderRadius,
                  autoValidate: AutovalidateMode.onUserInteraction,
                  validator: (val) =>
                      (val?.isEmpty ?? false) ? "Task name is missing" : null,
                  contentPadding: 10.padding,
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
                10.height,
                CustomVehiclePersonField(
                  vehiclesList: state.vehicles,
                  personsList: state.persons,
                  selected: state.selectedVPerson,
                  onSelected: (val) => context
                      .read<EditToDoBloc>()
                      .add(EditToDoVPersonEvent(val)),
                  controller: context.read<EditToDoBloc>().vPersonController,

                ),
                10.height,
                CustomVendorLocationField(
                  vendorsList: state.vendors,
                  locationsList: state.locations,
                  selected: state.selectedVendor,
                  onSelected: (val) => context
                      .read<EditToDoBloc>()
                      .add(EditToDoVLocationEvent(val)),
                  controller: context.read<EditToDoBloc>().vLocationController,
                ),
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
                const EditTodoBottomTabs(),
              ],
            )));
  }
}
