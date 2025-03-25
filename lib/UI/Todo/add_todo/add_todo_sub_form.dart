import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_task_identifier.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoSubForm extends StatelessWidget {
  const AddTodoSubForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          10.height,
          FocusTraversalOrder(
            order: const NumericFocusOrder(0),
            child: TaskIdentifier(
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
          ),
          10.height,
          FocusTraversalOrder(
            order: NumericFocusOrder(1),
            child: Utils.getTextFormField(
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
          ),
          10.height,
          FocusTraversalOrder(
            order: NumericFocusOrder(2),
            child: CustomVehiclePersonField(
              vehiclesList: state.vehicles,
              personsList: state.persons,
              groupVehicles: state.groupVehicles,
              selected: state.selectedVPerson,
              onSelected: (val) =>
                  context.read<AddToDoBloc>().add(AddToDoVPersonEvent(val)),
              controller: context.read<AddToDoBloc>().vPersonController,
            ),
          ),
          if (state.selectedVPerson
              .where((element) => ["vehicles", "g_vehicles"].contains(element['type']))
              .lastOrNull !=
              null)
            ...[
              10.height,
              Text.rich(TextSpan(
                  text: "View: Vehicle History",
                  recognizer: TapGestureRecognizer()..onTap = () => context.push(VehicleHistoryViewUI(
                      showSameTask: (state.selectedTaskIdentifier.containsKey(1)),
                      title: (state.selectedTaskIdentifier.containsKey(1)) ? state.selectedTaskIdentifier[1]['name'] : null,
                      vin: state.selectedVPerson
                          .where((element) => element['type'] == "vehicles")
                          .lastOrNull?['value']?['vin'],
                      vehicleName: state.selectedVPerson
                          .where((element) => element['type'] == "vehicles")
                          .lastOrNull?['name']), fullscreenDialog: true)),
                textAlign: TextAlign.end,
                style: context.textTheme.labelSmall?.copyWith(
                    color: AppC.appColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.appColor
                ),)
            ],
          10.height,
          FocusTraversalOrder(
            order: NumericFocusOrder(3),
            child: CustomVendorLocationField(
              vendorsList: context.watch<AddToDoBloc>().vendors,
              locationsList: context.watch<AddToDoBloc>().locations,
              selected: state.selectedTaskIdentifier,
              onCleared: (val) => context
                  .read<AddToDoBloc>()
                  .add(AddToDoVLocationEvent(null)),
              onSelected: (val) => context
                  .read<AddToDoBloc>()
                  .add(AddToDoVLocationEvent(val)),
              controller: context.read<AddToDoBloc>().vLocationController,
            ),
          ),
          if (state.selectedTaskIdentifier.containsKey(3) &&
              state.selectedTaskIdentifier[3]['type'] == 'location')
            ...[
              10.height,
              FocusTraversalOrder(
                order: NumericFocusOrder(4),
                child: SearchViewField<Map<String, dynamic>>(controller: context.read<AddToDoBloc>().addressController,
                    suggestions: List.from(state.selectedTaskIdentifier[3]['value']['addresses']),
                    selectedItem: state.addresses.lastOrNull,
                    labelText: "Address",
                    onCleared: (val) => context
                        .read<AddToDoBloc>()
                        .add(AddToDoAddressSelectionEvent(val, false)),
                    onSelected: (value) => context
                        .read<AddToDoBloc>()
                        .add(AddToDoAddressSelectionEvent(value, true)),
                    itemAsString: (item) => item['address'].toString()),
              )
            ],
          10.height,
          FocusTraversalOrder(
            order: NumericFocusOrder(5),
            child: Utils.getTextFormField(
                'Notes', context.read<AddToDoBloc>().notesController,
                isDense: true,
                contentPadding: 10.padding,
                labelStyle: context.textTheme.labelMedium
                    ?.copyWith(color: context.theme.hintColor),
                style: context.textTheme.labelLarge
                    ?.copyWith(fontFamily: "Lato"),
                readOnly: false,
                onChangeCallback: (value) {}),
          ),
          10.height,
          if (state.showPlatformCheck)
            Utils.getCircleCheckWidget(
                    () => context
                    .read<AddToDoBloc>()
                    .add(AddToDoPlatformCheckEvent()),
                state.isSelectedPlatformCheck,
                'Platform Check'),
        ],
      ),
    );
  }
}
