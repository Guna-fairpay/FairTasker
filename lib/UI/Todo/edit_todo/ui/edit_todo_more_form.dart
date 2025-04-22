
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/BackUps/supplies_view_ui.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/BackUps/part_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/Component/ask_date_range_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Utilities/str.dart';
import '../../../Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import '../bloc/edit_todo_bloc.dart';
import '../event/edit_todo_event.dart';
import '../state/edit_todo_state.dart';

class EditTodoMoreForm extends StatelessWidget {
  const EditTodoMoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 5,
        children: [
          if (state.selectedVLocations['type'] == 'location' && (state.isMoreEnable))
            SearchViewField<Map<String, dynamic>>(
                suggestions: List.from(state.selectedVLocations['value']['addresses'] ?? []),
                selectedItem: state.addresses.lastOrNull,
                controller: TextEditingController(),
                labelText: "Address",
                onCleared: (val) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoAddressSelectionEvent(val, false)),
                onSelected: (value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoAddressSelectionEvent(value, true)),
                itemAsString: (item) => item['address'].toString()),
          if (state.isMoreEnable)
            Row(
              spacing: 10,
              children: [
                Utils.getCircleCheckWidget(
                    () => context
                        .read<EditToDoBloc>()
                        .add(EditToDoShowPartsEvent()),
                    state.isPartServiceEnable,
                    'Parts/Services'),
                Utils.getCircleCheckWidget(
                    () => context
                        .read<EditToDoBloc>()
                        .add(EditToDoShowSuppliesEvent()),
                    state.isSuppliesEnable,
                    'Supplies'),
                if (state.showCleanCar && (DateTime.now().compareTo(state.selectedDate??DateTime.now()) == 1))
                  IconButton(
                    onPressed: () =>
                        context.read<EditToDoBloc>().add(EditToDoCleanCarEvent()),
                    icon: const Icon(Icons.local_car_wash_sharp),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide()))),
                  ),
                if (state.showCleanCar && (DateTime.now().compareTo(state.selectedDate??DateTime.now()) == 1))
                  Flexible(
                    child:    CustomDropdown<Map<String, dynamic>>(
                      contentPadding: 4.padding,
                      items: List.from(state.clearDurations),
                      value: state.selectedClearDuration,
                      itemAsString: (item) => item['value'].toString(),
                      onChanged: (value) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoCleanCarDuration(value)),
                    ),
                  )
              ],
            ),
          if (state.isMoreEnable && state.isPartServiceEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedParts),
                suggestionsList: List.from(state.partServices),
                controller: TextEditingController(),
                labelText: "Parts",
                itemAsString: (item) => item['name'].toString(),

                onChanged: (isChecked, value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoPartSelectionEvent(isChecked, value)),
                onEmptyTap: () =>
                    context.push(const PartsMainUI(), fullscreenDialog: true)),
          if (state.isMoreEnable && state.isSuppliesEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedSupplies),
                suggestionsList: List.from(state.supplies),
                controller: TextEditingController(),
                labelText: "Supplies",
                onChanged: (isChecked, value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSupplySelectionEvent(isChecked, value)),
                itemAsString: (item) => item['name'].toString(),
                onEmptyTap: () => context.push(const SuppliesMainUI(),
                    fullscreenDialog: true)
            ),
          if (state.isMoreEnable && (Str.completedOdometer.contains(state.apiResponse['title'])))
            Row(
            spacing: 15,
            children: [
              10.height,
              Expanded(child: Utils.getTextFormField("Trip driven miles", context.read<EditToDoBloc>().tripDrivenController,)),
              Expanded(child: Utils.dropdownBox(
                "Selected Sentiments",
                state.sentiments,
                    (val)=>context.read<EditToDoBloc>().add(EditToDoSelectSentimentsEvent(val)),
                labelKey: 'name',
                initialSelection: state.selectedSentiment,
              ),),
              10.height,
            ],
          ),
          Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<EditToDoBloc>().add(EditToDoShowMoreEvent()),
                child: Utils.getText(
                    '${state.isMoreEnable ? "Less" : "More"}...',
                    color: (state.isMoreEnable
                            ? Colors.lightBlue
                            : Colors.lightGreen)
                        .shade800),
              ),
              Flexible(
                  child: Utils.dropdownBox(
                      'Select',
                      state.linkOptions,
                      (val) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoSelectLinkOptionEvent(val)),
                      labelKey: 'label',
                      initialSelection: state.selectedLinkOption))
            ],
          ),
          5.height,
          if (state.selectedLinkOption != null)
            Utils.getTextFormField("${state.selectedLinkOption!['label']}",
                context.read<EditToDoBloc>().customLinkController,
                inputAction: TextInputAction.done,
                isDense: true,
                borderRadius: Num.borderRadius,
                contentPadding: 10.padding,
                labelStyle: context.textTheme.labelMedium
                    ?.copyWith(color: context.theme.hintColor),
                style:
                    context.textTheme.labelLarge?.copyWith(fontFamily: "Lato")),
          if ((Str.completedOdometer.contains(state.apiResponse['title'])
              && state.apiResponse['status']=="Completed")
              || (Str.unCompletedOdometer.contains(state.apiResponse['title'])))
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state.previousOdometer.toString() != '0')
                RichText(text: TextSpan(
                  text: 'Previous Odometer : ',
                  style: context.textTheme.labelMedium?.copyWith(),
                  children: [
                    TextSpan(
                      text: state.previousOdometer,
                      style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                Utils.getTextFormField(
                  'Odometer',
                  context.read<EditToDoBloc>().odometerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final inputValue = num.tryParse(value) ?? 0;
                    final minMileage = num.tryParse(state.previousOdometer) ?? 0;
                    return inputValue < minMileage
                        ? "Can't enter lower than previous oil change odometer"
                        : null;
                  },
                  autoValidate: AutovalidateMode.onUserInteraction,
                  inputAction: TextInputAction.done,
                  textType: const TextInputType.numberWithOptions(decimal: true),
                  textInputFormatter:[FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ],
            ),
          if (state.selectedVehicle.isNotEmpty && state.taskHistory.length > 1)
            Utils.dropdownBox(
                "Select Vehicle Name",
                state.taskHistory,
                (val) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSelectTaskHistoryEvent(val)),
                labelKey: 'vehicle_name',
                initialSelection: state.selectedVehicle),
          if (state.selectedVPerson.isNotEmpty && state.selectedVPerson.firstOrNull?['type'] != 'person' )
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VehicleHistoryViewUI(
                        showSameTask: true,
                            title: state.apiResponse['title'],
                            vin: state.selectedVehicle['vin'],
                            vehicleName: state.selectedVehicle['vehicle_name'],
                            groupId: state.selectedVPerson.first['id'],
                          )
                  )
              );
            },
            child:
              Utils.getText(
                'Task History - ${state.selectedVPerson.length == 1 ? state.selectedVehicle['vehicle_name'] ?? state.selectedVPerson.first['name'] : state.selectedVehicle['vin'] ?? ''}',
                color: AppC.appColor,
                weight: FontWeight.w500,
              ),
          ),
          if (state.selectedLinkOption != null)
            ValueListenableBuilder(
              valueListenable:
              context.read<EditToDoBloc>().customLinkController,
              builder: (context, value, child) => value.text.isEmpty
                  ? Container()
                  : Text.rich(
                TextSpan(
                    text:
                    "${state.selectedLinkOption!['label'].toString().isCustomLink ? "Link" : "Reservation No"} - ${value.text}",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context
                          .read<EditToDoBloc>()
                          .add(EditToDoOpenCustomLinkEvent())),
                textAlign: TextAlign.end,
                style: context.textTheme.labelMedium?.copyWith(
                    color: AppC.appColor,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.appColor),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SuccessButton(text: 'Update',onPressed: () {
                if(state.apiResponse['recurring_id']!=null){
                  AskPermissionDialog.show(
                    context,
                    title:
                    "Do you want to Update this task only?",
                    description:state.apiResponse['recurring'],
                    positiveText:"Yes, Update it!",
                    negativeText: "Cancel",
                    isReasonRequired: false,
                    subPositiveText:"Update multiple",
                    onSaveMultiPressed: () async {
                      if(state.selectedEndDate != null && state.selectedStartDate != null){
                        await Future.delayed(Durations.short1);
                        AskDateRangePermissionDialog.show(
                            context,
                            endDate: state.selectedEndDate?.toFormat(),
                            startDate: state.selectedStartDate?.toFormat(),
                            selectedEndDate: state.selectedEndDate,
                            selectedStartDate: state.selectedStartDate,
                            onStartDate: (value)=>context.read<EditToDoBloc>().add(EditToDoStartDateChangeEvent(value)),
                            onEndDate: (value)=>context.read<EditToDoBloc>().add(EditToDoEndDateChangeEvent(value)),
                            onPositivePressed: (){
                              context.read<EditToDoBloc>().add(
                                  EditToDoSaveEvent(isRecurring: true));
                            }
                        );
                      }

                    },
                    onPositivePressed: (){
                      context.read<EditToDoBloc>().add(
                          EditToDoSaveEvent(isRecurring: false));
                    },
                  );

                }else {
                  context.read<EditToDoBloc>().add(
                      EditToDoSaveEvent(isRecurring: false));
                }
              },),
            ],
          ),
          if (state.apiResponse['recurring'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText('Recurring Details',
                    color: AppC.appColor, weight: FontWeight.w500),
                Row(
                  children: [
                    const Icon(Icons.refresh),
                    20.width,
                    Expanded(
                      child:
                          Utils.getText(state.apiResponse['recurring'] ?? ''),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
