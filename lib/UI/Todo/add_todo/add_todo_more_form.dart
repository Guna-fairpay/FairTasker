import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/supplies_view_ui.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/part_view_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddTodoMoreForm extends StatelessWidget {
  const AddTodoMoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          if (state.isMoreEnable)
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
                if (state.showCleanCar)
                  IconButton(
                    onPressed: () =>
                        context.read<AddToDoBloc>().add(AddToDoCleanCarEvent()),
                    icon: const Icon(Icons.local_car_wash_sharp),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide()))),
                  ),
                if (state.showCleanCar)
                  Flexible(
                    child: CustomDropdown<dynamic>(
                      items: state.clearDurations,
                      value: state.selectedClearDuration,
                      itemAsString: (item) => item['value'].toString(),
                      onChanged: (value) => context
                          .read<AddToDoBloc>()
                          .add(AddToDoCleanCarDuration(value)),
                    ),
                  )
              ],
            ),
          if (state.isMoreEnable && state.isPartServiceEnable)
            CustomMultiSelectionChipsField<dynamic>(
                selectedPartsList: state.selectedParts,
                suggestionsList: state.partServices,
                controller: TextEditingController(),
                labelText: "Parts",
                itemAsString: (item) => item['name'].toString(),
                onChanged: (isChecked, value) => context
                    .read<AddToDoBloc>()
                    .add(AddToDoPartSelectionEvent(isChecked, value)),
                onEmptyTap: () =>
                    context.push(const PartViewUI(), fullscreenDialog: true)),
          if (state.isMoreEnable && state.isSuppliesEnable)
            CustomMultiSelectionChipsField<dynamic>(
                selectedPartsList: state.selectedSupplies,
                suggestionsList: state.supplies,
                controller: TextEditingController(),
                labelText: "Supplies",
                onChanged: (isChecked, value) => context
                    .read<AddToDoBloc>()
                    .add(AddToDoSupplySelectionEvent(isChecked, value)),
                itemAsString: (item) => item['name'].toString(),
                onEmptyTap: () => context.push(const SuppliesViewUI(),
                    fullscreenDialog: true)),
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
                child: CustomDropdown<dynamic>(
                  items: state.linkOptions,
                  value: state.selectedLinkOption,
                  onChanged: (val) => context.read<AddToDoBloc>().add(AddToDoSelectLinkOptionEvent(val)),
                  itemAsString: (item) => item['label'].toString(),
                ),
              )
            ],
          ),
          if (state.selectedLinkOption != null)
          Utils.getTextFormField(
              "${state.selectedLinkOption!['label']}", context.read<AddToDoBloc>().customLinkController,
              inputAction: TextInputAction.done,
            isDense: true,
            borderRadius: Num.borderRadius,
            contentPadding: 10.padding,
            style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato")
          ),
        ],
      ),
    );
  }
}
