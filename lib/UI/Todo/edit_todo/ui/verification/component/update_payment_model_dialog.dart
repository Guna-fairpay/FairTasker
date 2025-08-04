import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/bloc/verification_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePaymentModelDialog {
  UpdatePaymentModelDialog._();

  static void show(BuildContext context, {dynamic model}) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<VerificationBloc>(context),
          child: _UpdatePaymentModelDialog(model: model,)),
    );
  }
}

class _UpdatePaymentModelDialog extends StatelessWidget {
  final dynamic model;
  const _UpdatePaymentModelDialog({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const CompactText(
          "Update payment model",
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
                 Utils.dropdownBox('',
                  context.read<VerificationBloc>().updatePaymentMethod,
                         (v)=> context.read<VerificationBloc>().add(UpdatePaymentMethodEvent(v)),
                     labelKey: 'name',
                   initialSelection: context.read<VerificationBloc>().selectedPaymentMethod,
                 ),
                  SuccessButton(
                    text: 'Update',
                    onPressed: (){
                      context.read<VerificationBloc>().add(GenerateAgreementEvent(isChecked: true));
                      context.popDialog();},
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
