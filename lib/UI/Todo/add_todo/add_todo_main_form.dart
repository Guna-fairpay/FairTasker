import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/custom_task_identifier.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_more_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_recurring_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_recurring_sub_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_task_manager_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoMainForm extends StatelessWidget {
  const AddTodoMainForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
        builder: (context, state) => Form(
                child: ListView(
              children: [
                TaskIdentifier(
                  taskIdentifierController:
                      context.read<AddToDoBloc>().taskIdentifierController,
                  location: state.locations,
                  persons: state.persons,
                  tasks: state.tasks,
                  vehicles: state.vehicles,
                  vendors: state.vendors,
                  selected: state.selectedTaskIdentifier,
                  onSelected: (val) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoSelectedTaskIdentifierEvent(val)),
                ),
                10.height,
                Utils.getTextFormField(
                  'Task Name',
                  context.read<AddToDoBloc>().taskNameController,
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
                  onSelected: (val) =>
                      context.read<AddToDoBloc>().add(AddToDoVPersonEvent(val)),
                  controller: context.read<AddToDoBloc>().vPersonController,
                ),
                10.height,
                CustomVendorLocationField(
                  vendorsList: state.vendors,
                  locationsList: state.locations,
                  selected: state.selectedTaskIdentifier,
                  onSelected: (val) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoVLocationEvent(val)),
                  controller: context.read<AddToDoBloc>().vLocationController,
                ),
                if (state.selectedTaskIdentifier.containsKey(3) &&
                    state.selectedTaskIdentifier[3]['type'] == 'location')
                  10.height,
                if (state.selectedTaskIdentifier.containsKey(3) &&
                    state.selectedTaskIdentifier[3]['type'] == 'location')
                  CustomMultiSelectionChipsField<dynamic>(
                      selectedPartsList: state.addresses,
                      suggestionsList: state.selectedTaskIdentifier[3]['value']
                          ['addresses'],
                      controller: TextEditingController(),
                      labelText: "Address",
                      onChanged: (isChecked, value) => context
                          .read<AddToDoBloc>()
                          .add(AddToDoAddressSelectionEvent(value, isChecked)),
                      itemAsString: (item) => item['address'].toString()),
                10.height,
                Utils.getTextFormField(
                    'Notes', context.read<AddToDoBloc>().notesController,
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
                          .read<AddToDoBloc>()
                          .add(AddToDoPlatformCheckEvent()),
                      state.isSelectedPlatformCheck,
                      'Platform Check'),
                10.height,
                const AddTodoMoreForm(),
                10.height,
                const AddTodoTaskManagerForm(),
                10.height,
                const AddTodoRecurringForm(),
                10.height,
                const AddTodoRecurringSubForm(),
                16.height,
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(AppC.buttonColor),
                        textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                        foregroundColor: const WidgetStatePropertyAll(AppC.white),
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Num.borderRadiusLarge)))),
                    onPressed: () =>
                        context.read<AddToDoBloc>().add(AddToDoSaveEvent()),
                    child: const Text("Save"))
              ],
            )));
  }
}
