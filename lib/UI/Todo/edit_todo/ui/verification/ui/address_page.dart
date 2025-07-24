part of 'verification_main_ui.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          return context.read<VerificationBloc>().bookingDetails?['address_proof_status'] == "pending"
              ? const CompactText('No Address proof record available')
              :VerificationListingPage(
            controller: context.read<VerificationBloc>().notesController,
            forceOnChanged: (v)=> context.read<VerificationBloc>().add(ForceActionEvent()),
            approveOnTap: (v)=> context.read<VerificationBloc>().add(ApproveEvent(data: v)),
            rejectOnTap: (v)=> context.read<VerificationBloc>().add(RejectEvent(data: v)),
            checkList: context.read<VerificationBloc>().addressCheckList,
            attachments: context.read<VerificationBloc>().addressAttachments,
            checkListOnChange:(v)=> context.read<VerificationBloc>().add(CheckListEvent(v)),
            forceAction: context.watch<VerificationBloc>().forceAction,
          );
        });
  }
}
