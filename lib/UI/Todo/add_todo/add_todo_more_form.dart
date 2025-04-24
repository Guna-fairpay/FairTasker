import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddTodoMoreForm extends StatelessWidget {
  const AddTodoMoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 5,
        children: [
          if (state.selectedTaskIdentifier.containsKey(3) &&
              (state.selectedTaskIdentifier[3]['type'] == 'location') && (state.isMoreEnable))
            ...[
              10.height,
              SearchViewField<Map<String, dynamic>>(controller: context.read<AddToDoBloc>().addressController,
                  suggestions: List.from(state.selectedTaskIdentifier[3]['value']['addresses']),
                  selectedItem: state.addresses.lastOrNull,
                  labelText: "Address",
                  onCleared: (val) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoAddressSelectionEvent(val, false)),
                  onSelected: (value) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoAddressSelectionEvent(value, true)),
                  itemAsString: (item) => item['address'].toString())
            ],
          if (state.isMoreEnable || (context.watch<AddToDoBloc>().isNextTask))
            Row(
              spacing: 10,
              children: [
                Utils.getCircleCheckWidget(
                    () => context
                        .read<AddToDoBloc>()
                        .add(AddToDoShowPartsEvent()),
                    state.isPartServiceEnable,
                    'Parts/Services'),
                Utils.getCircleCheckWidget(
                    () => context
                        .read<AddToDoBloc>()
                        .add(AddToDoShowSuppliesEvent()),
                    state.isSuppliesEnable,
                    'Supplies'),

                if ((state.showCleanCar && (DateTime.now().compareTo(context.watch<AddToDoBloc>().addToDoDate) == 1)) && (!(context.watch<AddToDoBloc>().isNextTask)))
                  IconButton(
                    onPressed: () =>
                        context.read<AddToDoBloc>().add(AddToDoCleanCarEvent()),
                    icon: const Icon(Icons.local_car_wash_sharp),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide()))),
                  ),
                if ((state.showCleanCar && (DateTime.now().compareTo(context.watch<AddToDoBloc>().addToDoDate) == 1))  && (!(context.watch<AddToDoBloc>().isNextTask)))
                  Flexible(child: Utils.dropdownBox("", List.from(state.clearDurations),
                          initialSelection: state.selectedClearDuration,
                          (selectedValue) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoCleanCarDuration(selectedValue)), labelKey: "value")),
              ],
            ),
          if ((state.isMoreEnable || (context.watch<AddToDoBloc>().isNextTask)) && state.isPartServiceEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedParts),
                suggestionsList: List.from(state.partServices),
                controller: context.read<AddToDoBloc>().partsController,
                labelText: "Parts",
                itemAsString: (item) => item['name'].toString(),
                onChanged: (isChecked, value) => context
                    .read<AddToDoBloc>()
                    .add(AddToDoPartSelectionEvent(isChecked, value)),
                onEmptyTap: () =>
                    context.push(const PartsMainUI(), fullscreenDialog: true)),
          if ((state.isMoreEnable || (context.watch<AddToDoBloc>().isNextTask)) && state.isSuppliesEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedSupplies),
                suggestionsList: List.from(state.supplies),
                controller: context.read<AddToDoBloc>().suppliesController,
                labelText: "Supplies",
                onChanged: (isChecked, value) => context
                    .read<AddToDoBloc>()
                    .add(AddToDoSupplySelectionEvent(isChecked, value)),
                itemAsString: (item) => item['name'].toString(),
                onEmptyTap: () => context.push(const SuppliesMainUI(),
                    fullscreenDialog: true)),
          10.height,
          if (!(context.watch<AddToDoBloc>().isNextTask))
          Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<AddToDoBloc>().add(AddToDoShowMoreEvent()),
                child: Utils.getText(
                    '${state.isMoreEnable ? "Less" : "More"}...',
                    color: (state.isMoreEnable
                            ? Colors.lightBlue
                            : Colors.lightGreen)
                        .shade800),
              ),
              Flexible(
                child: CustomDropdown<Map<String, dynamic>>(
                  items: List.from(state.linkOptions),
                  value: state.selectedLinkOption,
                  contentPadding: 5.padding,
                  labelText: null,
                  hintText: "Select option",
                  onChanged: (val) => context
                      .read<AddToDoBloc>()
                      .add(AddToDoSelectLinkOptionEvent(val)),
                  itemAsString: (item) => item['label'].toString(),
                ),
              )
            ],
          ),
          if ((state.selectedLinkOption != null) && (!(context.watch<AddToDoBloc>().isNextTask)))
            Utils.getTextFormField("${state.selectedLinkOption!['label']}",
                context.read<AddToDoBloc>().customLinkController,
                inputAction: TextInputAction.done,
                isDense: true,
                borderRadius: Num.borderRadius,
                contentPadding: 10.padding,
                labelStyle: context.textTheme.labelMedium
                    ?.copyWith(color: context.theme.hintColor),
                style:
                    context.textTheme.labelLarge?.copyWith(fontFamily: "Lato")),
          if ((state.selectedLinkOption != null) && (!(context.watch<AddToDoBloc>().isNextTask)))
            ValueListenableBuilder(
              valueListenable: context.read<AddToDoBloc>().customLinkController,
              builder: (context, value, child) => value.text.isEmpty ? Container() : Text.rich(TextSpan(
                  text: "${state.selectedLinkOption!['label'].toString().isCustomLink ? "Link" : "Reservation No"} - ${value.text}",
                  recognizer: TapGestureRecognizer()..onTap = () => context.read<AddToDoBloc>().add(AddToDoOpenCustomLinkEvent())),
              textAlign: TextAlign.end,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.watch<AddToDoBloc>().reservationColor,
                decoration: TextDecoration.underline,
                decorationColor: AppC.appColor
              ),),
            )
        ],
      ),
    );
  }
}
