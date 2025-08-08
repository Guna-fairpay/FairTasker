part of 'verification_main_ui.dart';

class FinalAgreementPage extends StatelessWidget {
  const FinalAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          return context.read<VerificationBloc>().bookingDetails?['final_agreement_status'] == "pending"
              ? const CompactText(' Agreement status is pending')
              :['pending_admin_action', 'pending_action'].contains(context.read<VerificationBloc>().bookingDetails?['final_agreement_status'])
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const CompactText('No agreement documents available. Generate one below'),
              SuccessButton(text: 'Generate Agreement', onPressed: ()=> context.read<VerificationBloc>().add(GenerateAgreementEvent()), backgroundColor: AppC.appColor,),
            ],
          )
              :VerificationListingPage(
            controller: context.read<VerificationBloc>().notesController,
            forceOnChanged: (v)=> context.read<VerificationBloc>().add(ForceActionEvent()),
            approveOnTap: (v)=> context.read<VerificationBloc>().add(ApproveEvent(data: v)),
            rejectOnTap: (v)=> context.read<VerificationBloc>().add(RejectEvent(data: v)),
            checkList: context.read<VerificationBloc>().finalAgreementCheckList,
            attachments: context.watch<VerificationBloc>().finalAgreementAttachments,
            isPdf: true,
            showPDFButtons: true,
            checkListOnChange:(v)=> context.read<VerificationBloc>().add(CheckListEvent(v)),
            forceAction: context.watch<VerificationBloc>().forceAction,
            viewAgreement: (v)=> context.read<VerificationBloc>().add(ViewAgreementEvent(v)),
            generateAgreement: ()=> context.read<VerificationBloc>().add(GenerateAgreementEvent()),
          );
        });
  }
}
