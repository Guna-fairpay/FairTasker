part of 'verification_main_ui.dart';

class LicensePage extends StatelessWidget {
  const LicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
         return context.read<VerificationBloc>().bookingDetails?['license_status'] == "pending"
             ? const CompactText(' No record will be available')
             :VerificationListingPage(
           controller: context.read<VerificationBloc>().notesController,
           forceOnChanged: (v)=> context.read<VerificationBloc>().add(ForceActionEvent()),
           approveOnTap: (v)=> context.read<VerificationBloc>().add(ApproveEvent(data: v)),
           rejectOnTap: (v)=> context.read<VerificationBloc>().add(RejectEvent(data: v)),
           checkList: context.watch<VerificationBloc>().licenseCheckList,
           attachments: context.read<VerificationBloc>().licenseAttachments,
           checkListOnChange:(v)=> context.read<VerificationBloc>().add(CheckListEvent(v)),
           forceAction: context.watch<VerificationBloc>().forceAction,
         );
        });
  }
}
