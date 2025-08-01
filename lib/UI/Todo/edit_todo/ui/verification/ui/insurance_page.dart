part of 'verification_main_ui.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        bool showDelete = context.watch<VerificationBloc>().bookingDetails['insurance'] != null;
        List<dynamic> insuranceFile =[context.watch<VerificationBloc>().bookingDetails?['insurance']?['attachment']?['file_url']];
        bool showView = context.watch<VerificationBloc>().bookingDetails?['insurance']?['attachment'] != null;

        return Form(
          key: context.read<VerificationBloc>().formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckboxListTile(
                title: const CompactText('Information needed from customer', styleType: TextStyleType.labelMedium,),
                value: context.watch<VerificationBloc>().insuranceInfo,
                onChanged: (v)=> context.read<VerificationBloc>().add(InsuranceInformationCheckEvent()),
                padding: 0.padding,
              ),
              if(context.watch<VerificationBloc>().insuranceInfo) ...[
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Utils.getTextFormField(null,
                      context.read<VerificationBloc>().adminNotesController,
                      hintText: 'Enter admin notes',
                    ),
                  ),
                  CompactIconButton(
                    iconSize: 20.spMin,
                    icon: RemixIcons.save_2_line,
                    backgroundColor: AppC.green,
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 15.spMin, horizontal: 10.spMin)),
                    onPressed: ()=> context.read<VerificationBloc>().add(InsuranceInformationSaveEvent()),
                  ),
                ],
              ),],
              const CompactText(
                'Insurance Company Name',
                styleType: TextStyleType.labelLarge,
              ),
              Utils.getTextFormField(null,
                context.read<VerificationBloc>().insuranceCompanyNameController,
                hintText: 'Enter Insurance Company Name',
                autoValidate: context.watch<VerificationBloc>().autoValidateMode,
                validator: (value) => (value?.isNullOrEmpty ?? false) ? "insurance company name is required" : null,
              ),
              const CompactText('Insurance Type', styleType: TextStyleType.labelLarge,),
              Utils.getTextFormField(null,
                context.read<VerificationBloc>().insuranceTypeController,
                hintText: 'Enter Insurance Type',
                autoValidate: context.watch<VerificationBloc>().autoValidateMode,
                validator: (value) => (value?.isNullOrEmpty ?? false) ? "insurance type is required" : null,
              ),
              const CompactText('Paid By', styleType: TextStyleType.labelLarge,),
              Utils.getTextFormField(null,
                context.read<VerificationBloc>().paidByController,
                hintText: 'Enter who paid for the insurance',
                autoValidate: context.watch<VerificationBloc>().autoValidateMode,
                validator: (value) => (value?.isNullOrEmpty ?? false) ? "paid by is required" : null,
              ),
              const CompactText('Amount', styleType: TextStyleType.labelLarge,),
              Utils.getTextFormField(null,
                context.read<VerificationBloc>().insuranceAmountController ,
                hintText: 'Enter Insurance amount',
                textType: const TextInputType.numberWithOptions(decimal: true),
                textInputFormatter:[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),],
                autoValidate: context.watch<VerificationBloc>().autoValidateMode,
                validator: (value) => (value?.isNullOrEmpty ?? false) ? "insurance amount is required" : null,
              ),
              const CompactText('Expiry date', styleType: TextStyleType.labelLarge,),
              CustomDateTimePicker<DateTime>(
                controller: context.read<VerificationBloc>().expiryDateController,
                format: "MM-dd-yyyy",
                labelText: "dd-mm-yyyy",
                suffixIcon: Icon(Icons.calendar_month_rounded,
                    size: 18, color: context.theme.hintColor),
                textAlign: TextAlign.center,
                value: context.read<VerificationBloc>().selectedInsuranceExpiryDate,
                validator: (value) => (value == null) ? "Please select date" : null,
                autovalidateMode: context.watch<VerificationBloc>().autoValidateMode,
                onChanged: (value)=> context.read<VerificationBloc>().add(InsuranceExpiryDateEvent(value)),
              ),
              const CompactText('Insurance Document', styleType: TextStyleType.labelLarge,),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CompactFilePicker(
                      controller: context.read<VerificationBloc>().insuranceFileNameController,
                      onPressed:()=> context.read<VerificationBloc>().add(ChooseInsuranceFileEvent()),
                    ),
                  ),
                  if(context.watch<VerificationBloc>().insuranceAttachments.isNotEmpty)
                  InkWell(
                    onTap:()=> ImageViewDialog.show(context,
                      attachments: context.read<VerificationBloc>().insuranceAttachments,
                      onDelete: (v)=> context.read<VerificationBloc>().add(RemoveInsuranceFileEvent(data: v)),
                    ),
                      child: const Icon(RemixIcons.eye_fill, color: AppC.appColor,)),
                ],
              ),
              if(showView)
              SuccessButton(
                text: 'View',
                isOutline: true,
                foregroundColor: AppC.appColor,
                backgroundColor: AppC.white,
                onPressed: ()=> ImageViewDialog.show(context, attachments: insuranceFile,),),
              Row(
                spacing: 10,
                children: [
                  if(showDelete)
                  SuccessButton(
                    text: 'Delete',
                    backgroundColor: AppC.red,
                    onPressed: ()=> context.read<VerificationBloc>().add(DeleteAlertDialogEvent()),
                  ),
                  SuccessButton(
                    text: 'Save',
                    onPressed: ()=> context.read<VerificationBloc>().add(InsuranceSaveEvent()),
                  ),
                ],
              ),
              20.spMin.height,
            ],
          ),
        );
      }
    );
  }
}
