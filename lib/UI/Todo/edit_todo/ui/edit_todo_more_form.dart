
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/supplies_view_ui.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/part_view_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/str.dart';
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
                    state.isSuppliesEnable, 'Supplies'),
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
                    .read<EditToDoBloc>()
                    .add(EditToDoPartSelectionEvent(isChecked, value)),
                onEmptyTap: () =>
                    context.push(const PartViewUI(), fullscreenDialog: true)),
          if (state.isMoreEnable && state.isSuppliesEnable)
            CustomMultiSelectionChipsField<dynamic>(
                selectedPartsList: state.selectedSupplies,
                suggestionsList: state.supplies,
                controller: TextEditingController(),
                labelText: "Supplies",
                onChanged: (isChecked, value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSupplySelectionEvent(isChecked, value)),
                itemAsString: (item) => item['name'].toString(),
                onEmptyTap: () => context.push(const SuppliesViewUI(),
                    fullscreenDialog: true)),
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
                child: Utils.dropdownBox('Select', state.linkOptions,
                        (val) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSelectLinkOptionEvent(val)),
                    labelKey: 'label')
              )
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
          if (state.selectedLinkOption != null)
            ValueListenableBuilder(
              valueListenable: context.read<EditToDoBloc>().customLinkController,
              builder: (context, value, child) => value.text.isEmpty ? Container() : Text.rich(TextSpan(
                  text: "${state.selectedLinkOption!['label'].toString().isCustomLink ? "Link" : "Reservation No"} - ${value.text}",
                  recognizer: TapGestureRecognizer()..onTap = () => context.read<EditToDoBloc>().add(EditToDoOpenCustomLinkEvent())),
                textAlign: TextAlign.end,
                style: context.textTheme.labelSmall?.copyWith(
                    color: AppC.appColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.appColor
                ),),
            ),
          if(Str.odometer.contains(state.apiResponse['title']))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText('Previous Odometer : '),
                Utils.getTextFormField('Odometer', context.read<EditToDoBloc>().odometerController,),
              ],
            ),

        ],
      ),
    );
  }
}