import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_state.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class TaskerStatusNewTask extends StatelessWidget {
  const TaskerStatusNewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskerStatusBloc, TaskerStatusState>(builder: (context, state) => ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Text("Next Task", style: context.textTheme.labelMedium?.copyWith(fontSize: 12.sp)),
        5.sp.height,
        MultiDropdown<Map<String, dynamic>>(
          key: UniqueKey(),
          searchEnabled: true,
          controller: context.read<TaskerStatusBloc>().controller,
          dropdownDecoration: DropdownDecoration(borderRadius: BorderRadius.circular(Num.borderRadius)),
          fieldDecoration: FieldDecoration(
            borderRadius: Num.borderRadius,
            hintStyle: context.textTheme.labelLarge?.copyWith(color: context.theme.hintColor),
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppC.borderColor, width: Num.borderWidthField)),
          ),
          // onSelectionChange: (selectedItems) => context.read<TaskerStatusBloc>().add(TaskerStatusSelectTaskEvent(selectedItems)),
          focusNode: context.read<TaskerStatusBloc>().taskFocusNode,
          items: context.watch<TaskerStatusBloc>().tasks?.map((e) => DropdownItem<Map<String, dynamic>>(
              value: e, label: (e['checklist_name'] ?? ""))).toList() ?? [],
        ),
        10.sp.height,
        CompactTextField(hintText: "Custom Task", controller: context.read<TaskerStatusBloc>().taskController, focusNode: context.read<TaskerStatusBloc>().customFocusNode,),
        10.sp.height,
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: CustomDateTimePicker<DateTime>(
                  format: "MM-dd-yyyy",
                  controller: context.read<TaskerStatusBloc>().dateController,
                  value: context.watch<TaskerStatusBloc>().selectedDate,
                  onChanged: (v) => context.read<TaskerStatusBloc>().add(TaskerStatusDateEvent(v)),
                  suffixIcon: Icon(Icons.calendar_month_rounded,
                      size: 15, color: context.theme.hintColor),
                )),
            Expanded(
                child: CustomDateTimePicker<TimeOfDay>(
                  format: "HH:mm",
                  use24HourFormat: true,
                  value: context.watch<TaskerStatusBloc>().selectedTime,
                  onChanged: (v) => context.read<TaskerStatusBloc>().add(TaskerStatusTimeEvent(v)),
                  controller: context.read<TaskerStatusBloc>().timeController,
                  suffixIcon: Icon(Icons.access_time_rounded,
                      size: 15, color: context.theme.hintColor),
                )),
          ],
        ),
        10.sp.height,
        Utils.dropdownBox(
          "Select Resource",
          context.watch<TaskerStatusBloc>().resourcesList,
          (val) => context.read<TaskerStatusBloc>().add(TaskerStatusSelectResourceEvent(val)),
          labelKey: "first_name",
          labelKey2: "last_name",
          initialSelection: context.watch<TaskerStatusBloc>().selectedResource,
        ),
        10.sp.height,
        CustomVendorLocationField(
          enableEmptyWidget: false,
          vendorsList: context.watch<TaskerStatusBloc>().vendorsList,
          locationsList: context.watch<TaskerStatusBloc>().locationsList,
          selected: {3: context.watch<TaskerStatusBloc>().selectedVendorLocation},
          onSelected: (val) => context.read<TaskerStatusBloc>().add(TaskerStatusVendorLocationEvent(val)),
          controller: context.read<TaskerStatusBloc>().vendorLocationController,
        ),
        if (context.watch<TaskerStatusBloc>().selectedVendorLocation?['type'] == 'location')
          ...[
            10.sp.height,
            SearchViewField<Map<String, dynamic>>(
                suggestions: context.watch<TaskerStatusBloc>().addressList,
                selectedItem: context.watch<TaskerStatusBloc>().selectedAddress,
                controller: context.read<TaskerStatusBloc>().addressController,
                labelText: "Address",
                onCleared: (val) => context.read<TaskerStatusBloc>().add(TaskerStatusAddressEvent(null)),
                onSelected: (value) => context.read<TaskerStatusBloc>().add(TaskerStatusAddressEvent(value)),
                itemAsString: (item) => item['address'].toString()),
          ],
        10.sp.height,
        FocusNodeWrapper(builder: (focusNode) => CompactTextField(hintText: "Notes", controller: context.read<TaskerStatusBloc>().notesController, focusNode: focusNode)),
        10.sp.height,
        Row(
          spacing: 10.sp,
          children: [
            SuccessButton(
              text: "Save",
              onPressed: () {},
            ),
            SuccessButton(
              text: "Ignore",
              backgroundColor: AppC.red,
              onPressed: () {},
            )
          ],
        ),
        10.sp.height,
      ],
    ));
  }
}
