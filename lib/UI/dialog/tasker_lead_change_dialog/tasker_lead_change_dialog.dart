import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/ui/leads_main_ui.dart';
import 'package:fairpytasker/UI/dialog/tasker_lead_change_dialog/bloc/lead_change_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LeadChangeDialog {
  LeadChangeDialog._();

  static void show(BuildContext context, {Map<String, dynamic>? model, void Function(Map<String, dynamic> value, {Map<String, dynamic>? model})? onSelected}) async {
    await showDialog(
      context: context,
      builder: (context) => _LeadChangeDialogView(model: model, key: UniqueKey(), onSelected: onSelected),
      barrierDismissible: false,
    );
  }
}

class _LeadChangeDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(Map<String, dynamic> value, {Map<String, dynamic>? model})? onSelected;
  const _LeadChangeDialogView({super.key, required this.model, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: model?['display']?['task_title'],
      content: BlocProvider(create: (context) => LeadChangeBloc()..initialize(model: model),
        child: BlocConsumer<LeadChangeBloc, LeadChangeState>(
          builder: (context, state) => SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5.spMin,
              children: [
                Expanded(
                  child: SearchViewField<Map<String, dynamic>>(
                    showEmpty: true,
                    controller: context.read<LeadChangeBloc>().controller,
                    suggestions: context.watch<LeadChangeBloc>().leads,
                    itemAsString: (item) => item['name'] ?? "",
                    onSelected: context.read<LeadChangeBloc>().onChanged,
                    onEmptyTap: context.read<LeadChangeBloc>().onEmptyTap,
                  ),
                ),
                SuccessButton(
                  text: "Save",
                  onPressed: context.read<LeadChangeBloc>().onSave,
                ),
              ],
            ),
          ),
          listener: (context, state) {
            if (state is LoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              if ((state is CompleteState) || (state is CloseState)) {
                if (state is CompleteState) onSelected?.call(state.model, model: model);
                context.pop();
              } else if (state is EmptyLeadState) {
                context.push(LeadsMainUI(customerName: state.message));
              }
            }
          }),
      ),
    );
  }
}
