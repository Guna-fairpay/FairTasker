import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/bloc/verification_bloc.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPaymentDialog {
  AddPaymentDialog._();

  static void show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<VerificationBloc>(context),
          child: const _AddPaymentDialog()),
    );
  }
}

class _AddPaymentDialog extends StatelessWidget {
  const _AddPaymentDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const CompactText(
          "Add Manual payment",
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
          return SizedBox(
            width: context.width,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20.spMin),
             // crossAxisAlignment: CrossAxisAlignment.start,
             // mainAxisSize: MainAxisSize.min,
             // spacing: 10,
              children: [
                const CompactText('Initial payment', fontWeight: FontWeight.bold,),
                10.spMin.height,
                Utils.getTextFormField("",
                    context.read<VerificationBloc>().initialPaymentController,
                    readOnly: true,
                  fillColor: Colors.grey.shade200
                ),
                10.spMin.height,
                const CompactText('Payment type', fontWeight: FontWeight.bold,),
                10.spMin.height,
                Utils.dropdownBox('',
                    context.read<VerificationBloc>().paymentTypes,
                        (v)=> context.read<VerificationBloc>().add(PaymentTypeEvent(v)),
                    initialSelection: context.read<VerificationBloc>().selectedPaymentType,
                    labelKey: 'name'),
                10.spMin.height,
                const CompactText('Payment Method', fontWeight: FontWeight.bold,),
                10.spMin.height,
                Utils.getTextFormField("",
                    context.read<VerificationBloc>().paymentMethodController,
                    readOnly: true,
                    fillColor: Colors.grey.shade200
                ),
                10.spMin.height,
                const CompactText('Transaction number', fontWeight: FontWeight.bold,),
                10.spMin.height,
                Utils.getTextFormField("Transaction number",
                    context.read<VerificationBloc>().transactionNumberController,
                ),
                10.spMin.height,
                const CompactText('Attachments', fontWeight: FontWeight.bold,),
                10.spMin.height,
                CompactFilePicker(
                  controller: context.read<VerificationBloc>().imageNameController,
                  onPressed:()=> context.read<VerificationBloc>().add(PaymentAttachmentEvent()),
                ),
                10.spMin.height,
                ImageUploadSection(
                  title: 'Preview',
                  borderColor: Colors.blue,
                  onRemove: (file)=> context.read<VerificationBloc>().add(RemovePaymentAttachmentEvent(file)),
                  images: context.read<VerificationBloc>().addPaymentAttachments,
                  logName: "AddPaymentEvent",
                  isRequired: false,
                ),
                10.spMin.height,
                SuccessButton(onPressed: (){
                  context.read<VerificationBloc>().add(SavePaymentEvent());
                  context.popDialog();
                } ),
              ],
            ),
          );
        }
      ),
    );
  }
}
