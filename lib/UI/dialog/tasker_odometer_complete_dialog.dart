import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog_bloc/tasker_odometer_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog_bloc/tasker_odometer_complete_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog_bloc/tasker_odometer_complete_states.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerOdometerCompleteDialog {
  TaskerOdometerCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      {void Function(num currentOdometer, num nextMileCheck, num nextOdometer)?
          onChanged}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => _TaskerOdometerCompleteDialog(model: model, onChanged: onChanged),
    );
  }
}

class _TaskerOdometerCompleteDialog extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(num currentOdometer, num nextMileCheck, num nextOdometer)? onChanged;

  const _TaskerOdometerCompleteDialog({required this.model, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding,
      titlePadding: 16.padding,
      title: ListTile(
        dense: true,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        minTileHeight: 0,
        title: const Text(""),
        contentPadding: EdgeInsets.zero,
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      contentPadding: 20.padding,
      content: BlocProvider(
        create: (context) => TOCDBloc()..add(TOCDInitialEvents(model)),
        child: BlocListener<TOCDBloc, TOCDStates>(
            listener: (context, state) {
              if (state is TOCDLoadingState) {
                if (!EasyLoading.isShow) EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch (state) {
                  case TOCDErrorState():
                    Toaster.showError(state.message);
                    break;
                  case TOCDSuccessState():
                    Toaster.showSuccess(state.message);
                    break;
                  default:
                    break;
                }
              }
            },
            child: _TaskerOdometerCompleteDialogBodyView(onChanged: onChanged)),
      ),
    );
  }
}

class _TaskerOdometerCompleteDialogBodyView extends StatelessWidget {
  final void Function(num currentOdometer, num nextMileCheck, num nextOdometer)? onChanged;
  const _TaskerOdometerCompleteDialogBodyView({this.onChanged});

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TOCDBloc, TOCDStates>(
        builder: (context, state) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  if ((context
                              .watch<TOCDBloc>()
                              .previousOdometerResponse?['data'] ??
                          0) >
                      0)
                    Text.rich(
                      TextSpan(
                          text: "Previous Oil Change Odometer : ",
                          children: [
                            TextSpan(
                                text:
                                    "${context.watch<TOCDBloc>().previousOdometerResponse?['data'] ?? 0}",
                                style: context.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w900))
                          ]),
                      style: context.textTheme.labelLarge,
                    ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Utils.getText(
                          'Oil Change Odometer',
                          weight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Utils.getText(
                          'Next Miles Check',
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Utils.getTextFormField(
                          'Oil Change Odometer',
                          autoValidate: AutovalidateMode.always,
                          context.read<TOCDBloc>().oilChangeController,
                          inputAction: TextInputAction.next,
                          textType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                          validator: (val) => (double.tryParse(
                                          val.toString()) ??
                                      0) <
                                  (double.tryParse(
                                          "${context.watch<TOCDBloc>().previousOdometerResponse?['data'] ?? 0}") ??
                                      0)
                              ? "Cannot enter lower than previous oil change odometer"
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Utils.getTextFormField(
                            'Next Miles Check',
                            textType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            context.read<TOCDBloc>().nextMilesCheckController,
                            inputAction: TextInputAction.done),
                      ),
                    ],
                  ),
                  Utils.getText('Next Odometer', weight: FontWeight.bold),
                  Utils.getTextFormField('Next Odometer',
                      context.read<TOCDBloc>().nextOdometerController,
                      readOnly: true),
                  if (onChanged != null)
                  Utils.getFilledButton('Submit', () {
                    var currentOdometer = num.tryParse(context.read<TOCDBloc>().oilChangeController.text);
                    var nextMileCheck = num.tryParse(context.read<TOCDBloc>().nextMilesCheckController.text);
                    var nextOdometer = num.tryParse(context.read<TOCDBloc>().nextOdometerController.text);
                    onChanged?.call(currentOdometer ?? 0, nextMileCheck ?? 0, nextOdometer ?? 0);
                    context.popDialog();
                  }),
                ],
              ),
            ));
  }
}
