import 'package:fairpytasker/Component/custom_task_identifier.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_more_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_recurring_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_task_manager_form.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class AddTodoMainForm extends StatelessWidget {
  const AddTodoMainForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: ListView(
      children: [
        TaskIdentifier(
          taskIdentifierController: TextEditingController(),
          location: [],
          persons: [],
          tasks: [],
          vehicles: [],
          vendors: [],
          selectedTask: ValueNotifier({}),
          selectedVLocations: ValueNotifier({}),
          selectedVPersons: ValueNotifier([]),
        ),
        10.height,
        Utils.getTextFormField(
          'Task Name',
          TextEditingController(),
          label: Utils.getText('Task Name'),
        ),
        10.height,
        CustomVehiclePersonField(
          vehiclesList: [],
          personsList: [],
          selectedVPersons: ValueNotifier([]),
          controller: TextEditingController(),
        ),
        10.height,
        CustomVendorLocationField(
          vendorsList: [],
          locationsList: [],
          selectedVLocations: ValueNotifier({}),
          controller: TextEditingController(),
        ),
        10.height,
        Utils.getTextFormField('Notes', TextEditingController(),
            label: Utils.getText('Notes'),
            readOnly: false,
            onChangeCallback: (value) {}),
        10.height,
        Utils.getCircleCheckWidget(() {
        }, false, 'Platform Check'),
        10.height,
        const AddTodoMoreForm(),
        10.height,
        const AddTodoTaskManagerForm(),
        10.height,
        const AddTodoRecurringForm(),
      ],
    ));
  }
}
