
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class NextTaskUI extends StatelessWidget {
  final Function? onSave;
  final Function? onIgnore;
  const NextTaskUI({super.key, this.onSave, this.onIgnore});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCCDBloc, TCCDState>(
        builder: ( context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Utils.getText("Next Task",),
            MultiDropdown<Map<String, dynamic>>(
              key: UniqueKey(),
              // onSelectionChange: (selectedItems)=>context.read<TCCDBloc>().add(CheckListsDropdownEvent(value: selectedItems)),
              controller: context.read<TCCDBloc>().controller,
              items:((List.from(context.watch<TCCDBloc>().model?['checklists']??[])).map(
                    (e) => DropdownItem<Map<String, dynamic>>(
                    value: e, label: (e['checklist_name'] ?? "")),
              ).toList()),
              searchEnabled: true,

            ),
            Utils.getTextFormField("Custom Task", TextEditingController()),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: CustomDateTimePicker<DateTime>(
                      format: "dd-MM-yyyy",
                      controller: context.read<TCCDBloc>().dateController,
                      value: context.read<TCCDBloc>().selectedDate,
                      onChanged:(v)=> context.read<TCCDBloc>().add(DateChangeEvent(selectedDate: v,)),
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 15, color: context.theme.hintColor),
                    )),
                Expanded(
                    child: CustomDateTimePicker<TimeOfDay>(
                      format: "HH:mm",
                      use24HourFormat: true,
                      value: context.read<TCCDBloc>().selectedTime,
                      onChanged:(v)=> context.read<TCCDBloc>().add(TimeChangeEvent(selectedTime: v,)),
                      controller: context.read<TCCDBloc>().timeController,
                      suffixIcon: Icon(Icons.access_time_rounded,
                          size: 15, color: context.theme.hintColor),
                    )),
              ],
            ),
            Utils.dropdownBox("Select", context.read<TCCDBloc>().resource, (val) {}, labelKey: "first_name", labelKey2: "last_name"),
            CustomVendorLocationField(
              vendorsList: context.watch<TCCDBloc>().vendor,
              locationsList: context.watch<TCCDBloc>().location,
              selected: {3: context.read<TCCDBloc>().selectedVLocations},
              onSelected: (val) => context
                  .read<TCCDBloc>()
                  .add(VLocationChangeEvent(val)),
              controller: context.read<TCCDBloc>().vLocationController,
            ),
            if(context.watch<TCCDBloc>().selectedVLocations?['type'] == 'location')
              SearchViewField<Map<String, dynamic>>(
                  suggestions: List.from(context.watch<TCCDBloc>().selectedVLocations?['value']['addresses'] ?? []),
                  selectedItem: context.watch<TCCDBloc>().addresses.lastOrNull,
                  controller: TextEditingController(),
                  labelText: "Address",
                  onCleared: (val) => context
                      .read<TCCDBloc>()
                      .add(AddressSelectionEvent(val, false)),
                  onSelected: (value) => context
                      .read<TCCDBloc>()
                      .add(AddressSelectionEvent(value, true)),
                  itemAsString: (item) => item['address'].toString()),
            Utils.getTextFormField("Notes", TextEditingController()),
            Row(
              spacing: 20,
              children: [
                SuccessButton(
                  text: "Save",
                  onPressed: (){
                    onSave?.call();
                    context.pop();
                  },
                ),
                SuccessButton(
                  text: "Ignore",
                  backgroundColor: AppC.red,
                  onPressed:(){
                    onIgnore?.call();
                    context.pop();
                  },
                )
              ],
            ),]
        ));
  }
}
