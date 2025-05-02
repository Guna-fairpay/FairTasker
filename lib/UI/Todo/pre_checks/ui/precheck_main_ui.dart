import 'package:fairpytasker/UI/Todo/pre_checks/bloc/precheck_bloc.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/bloc/precheck_event.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/bloc/precheck_state.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/ui/precheck_list_item.dart';
import 'package:fairpytasker/UI/dialog/maintenance_check/maintenance_check_confirmation_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreCheckMainUi extends StatelessWidget {
  final Map<String, dynamic>? model;

  const PreCheckMainUi({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreCheckBloc()..add(PreCheckInitialEvent(model)),
      child: BlocListener<PreCheckBloc, PreCheckState>(
        listener: (context, state) {
          if (state is PreCheckLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case PreCheckSuccessState(): Toaster.showSuccess(state.message, context: context); break;
              case PreCheckErrorState(): Toaster.showError(state.message, context: context); break;
              case PreCheckCompleteState(): context.pop(); break;
              case PreCheckPopupState(): MaintenanceCheckConfirmDialog.show(context, model: state.model,
                  onComplete: () {},
                  onUpdate: (model) {},
                  onDelete: () {}); break;
            }
          }
        },
        child: BlocBuilder<PreCheckBloc, PreCheckState>(
          builder: (context, state) => ListView.separated(
            itemCount: context.watch<PreCheckBloc>().checkLists.length,
            shrinkWrap: true,
            padding: 5.sp.padding,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 5.sp.height,
            itemBuilder: (context, index) {
              var model = context.watch<PreCheckBloc>().checkLists[index];
              return PreCheckListItem(
                  key: UniqueKey(),
                  model: model,
                  onChanged: (value) => context
                      .read<PreCheckBloc>()
                      .add(PreCheckCheckEvent(model, value)),
                  onCreateTask: () =>
                      context.read<PreCheckBloc>().add(PreCheckSubmitEvent()));
            },
          ),
        ),
      ),
    );
  }
}
