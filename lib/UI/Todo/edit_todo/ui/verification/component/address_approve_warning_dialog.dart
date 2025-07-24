import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/bloc/verification_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressApproveWarningDialog {
  AddressApproveWarningDialog._();

  static void show(BuildContext context, {dynamic model}) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<VerificationBloc>(context),
          child: _AddressApproveWarningDialog(model: model,)),
    );
  }
}

class _AddressApproveWarningDialog extends StatelessWidget {
  final dynamic model;
  const _AddressApproveWarningDialog({
    this.model,
});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const CompactText(
          "Incomplete Checklist",
          fontWeight: FontWeight.bold,
          styleType: TextStyleType.titleMedium,
        ),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      insetPadding: 10.horizontalPadding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      contentPadding: 15.horizontalPadding,
      content: BlocBuilder<VerificationBloc, VerificationState>(
          builder: (context, state) {
            return Container(
              width: double.maxFinite,
              padding: 10.bottomPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children:[
                  const CompactText('Not all checklist items are completed. Are you sure you want to approve without completing the checklist?'),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SuccessButton(text: 'close', onPressed: context.popDialog, backgroundColor: Colors.black54,),
                      SuccessButton(
                          text: 'Approve anyway',
                          backgroundColor: AppC.appColor,
                          onPressed: (){
                            context.read<VerificationBloc>().add(ApproveEvent(data: model, isDialog: true));
                            context.popDialog();
                          }
                      ),
                    ],
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
