import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class NextTaskUI extends StatelessWidget {
  const NextTaskUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCCDBloc, TCCDState>(
        builder: (context, state) => !(context.watch<TCCDBloc>().showNextTask)
        ? const SizedBox.shrink()
            : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Utils.getText("Next Task", size: 12.sp),
              MultiDropdown<Map<String, dynamic>>(
                dropdownDecoration: DropdownDecoration(
                  borderRadius: BorderRadius.circular(Num.borderRadius)
                ),
                fieldDecoration: FieldDecoration(
                  borderRadius: Num.borderRadius,
                  hintStyle: context.textTheme.labelLarge?.copyWith(color: context.theme.hintColor),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppC.borderColor, width: Num.borderWidthField)
                  ),
                ),
                key: UniqueKey(),
                // onSelectionChange: (selectedItems)=>context.read<TCCDBloc>().add(CheckListsDropdownEvent(value: selectedItems)),
                controller: context.read<TCCDBloc>().controller,
                items: ((List.from(context.watch<TCCDBloc>().model?['checklists'] ?? []))
                    .map((e) => DropdownItem<Map<String, dynamic>>(
                    value: e, label: (e['checklist_name'] ?? ""))).toList()),
                searchEnabled: true,
              ),
              Utils.getTextFormField("Custom Task", context.read<TCCDBloc>().customTaskController),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: CustomDateTimePicker<DateTime>(
                        format: "MM-dd-yyyy",
                        controller: context.read<TCCDBloc>().dateController,
                        value: context.read<TCCDBloc>().selectedDate,
                        onChanged: (v) =>
                            context.read<TCCDBloc>().add(DateChangeEvent(
                              selectedDate: v,)),
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 15, color: context.theme.hintColor),
                      )),
                  Expanded(
                      child: CustomDateTimePicker<TimeOfDay>(
                        format: "HH:mm",
                        use24HourFormat: true,
                        value: context.read<TCCDBloc>().selectedTime,
                        onChanged: (v) =>
                            context.read<TCCDBloc>().add(TimeChangeEvent(
                                  selectedTime: v,
                                )),
                        controller: context.read<TCCDBloc>().timeController,
                        suffixIcon: Icon(Icons.access_time_rounded,
                            size: 15, color: context.theme.hintColor),
                      )),
                ],
              ),
              Utils.dropdownBox(
                "Select Resource",
                context.read<TCCDBloc>().resource,
                    (val) => context.read<TCCDBloc>().add(ResourceChangeEvent(data: val)),
                labelKey: "first_name",
                labelKey2: "last_name",
                initialSelection:
                context.watch<TCCDBloc>().selectedResource,
              ),
              CustomVendorLocationField(
                enableEmptyWidget: false,
                vendorsList: context.watch<TCCDBloc>().vendor,
                locationsList: context.watch<TCCDBloc>().location,
                selected: {3: context.read<TCCDBloc>().selectedVLocations},
                onSelected: (val) =>
                    context.read<TCCDBloc>().add(VLocationChangeEvent(val)),
                controller: context.read<TCCDBloc>().vLocationController,
              ),
              if (context.watch<TCCDBloc>().selectedVLocations?['type'] == 'location')
                SearchViewField<Map<String, dynamic>>(
                    suggestions: List.from(context
                        .watch<TCCDBloc>()
                        .selectedVLocations?['value']['addresses'] ?? []),
                    selectedItem: context.watch<TCCDBloc>().addresses.lastOrNull,
                    controller: TextEditingController(),
                    labelText: "Address",
                    onCleared: (val) => context.read<TCCDBloc>()
                        .add(AddressSelectionEvent(val, false)),
                    onSelected: (value) => context.read<TCCDBloc>()
                        .add(AddressSelectionEvent(value, true)),
                    itemAsString: (item) => item['address'].toString()),
              Utils.getTextFormField("Notes", context.read<TCCDBloc>().notesController),
              Row(
                spacing: 20,
                children: [
                  SuccessButton(
                    text: "Save",
                    onPressed: ()=>context.read<TCCDBloc>().add(SaveEvent()),
                  ),
                  SuccessButton(
                    text: "Ignore",
                    backgroundColor: AppC.red,
                    onPressed: ()=>context.read<TCCDBloc>().add(IgnoreEvent()),
                  )
                ],
              ),
            ]
        )
    );
  }
}
