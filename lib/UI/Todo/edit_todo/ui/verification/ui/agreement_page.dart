part of 'verification_main_ui.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          return context.read<VerificationBloc>().bookingDetails?['agreement_status'] == "pending"
              ? const CompactText(' Agreement status is pending')
              :['pending_admin_action', 'pending_action'].contains(context.read<VerificationBloc>().bookingDetails?['agreement_status'])
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  const CompactText('No agreement documents available. Generate one below'),
                  SuccessButton(text: 'Generate Agreement', onPressed: (){}, backgroundColor: AppC.appColor,),
                ],
              )
              :VerificationListingPage(
            controller: context.read<VerificationBloc>().notesController,
            forceOnChanged: (v)=> context.read<VerificationBloc>().add(ForceActionEvent()),
            approveOnTap: (v)=> context.read<VerificationBloc>().add(ApproveEvent(data: v)),
            rejectOnTap: (v)=> context.read<VerificationBloc>().add(RejectEvent(data: v)),
            checkList: context.read<VerificationBloc>().agreementCheckList,
            attachments: context.read<VerificationBloc>().agreementAttachments,
            isPdf: true,
            showPDFButtons: true,
            checkListOnChange:(v)=> context.read<VerificationBloc>().add(CheckListEvent(v)),
            forceAction: context.watch<VerificationBloc>().forceAction,
          );
        });
  }
}
