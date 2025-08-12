import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/cohort_change_dialog/bloc/cohort_change_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CohortChangeDialog {
  CohortChangeDialog._();

  static void show(BuildContext context, {required dynamic cohort,}) async {
    await showDialog(
        context: context,
        builder: (dialogContext) => _CohortChangeDialog(cohort: cohort,)
    );
  }
}

class _CohortChangeDialog extends StatelessWidget {
  final dynamic cohort;
  const _CohortChangeDialog({
    required this.cohort,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppC.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: BlocProvider(
          create: (context) => CohortChangeDialogBloc()..add(InitialEvent(data: cohort)),
          child: BlocListener<CohortChangeDialogBloc, CohortChangeDialogState>(
            listener: (context, state) {
              if(state is LoadingState){
                if(!EasyLoading.isShow) EasyLoading.show();
              }else{
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.message); break;
                  case SuccessState():
                    {
                      Toaster.showSuccess(state.data);
                      context.pop();
                    } break;
                }
              }
            },
            child: BlocBuilder<CohortChangeDialogBloc, CohortChangeDialogState>(
              builder: (context, state) {
                var expense = context.watch<CohortChangeDialogBloc>().model;
                return Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: expense?['vehicle']?['vehicle_name'] ?? '',
                              ),
                              TextSpan(text:  " (\$${expense?['expense_amount'] ??''})",)
                            ],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppC.appColor
                            ),
                          )),
                        ),
                        IconButton(onPressed: ()=> context.pop(), icon: const Icon(Icons.close, color: AppC.redAccent)),
                      ],
                    ),
                    const CompactText('Cohort', fontWeight: FontWeight.w400),
                    Utils.dropdownBox(
                      'Select Cohort',
                      context.watch<CohortChangeDialogBloc>().cohort,
                          (value)=> context.read<CohortChangeDialogBloc>().add(CohortDropdownEvent(data: value)),
                      labelKey: 'name',
                      initialSelection: context.watch<CohortChangeDialogBloc>().selectedCohort,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        SuccessButton(
                          text: 'Save',
                          onPressed: ()=> context.read<CohortChangeDialogBloc>().add(UpdateCohortEvent()),
                        ),
                      ],
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
