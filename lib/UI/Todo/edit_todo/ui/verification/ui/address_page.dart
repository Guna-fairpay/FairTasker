part of 'verification_main_ui.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          return VerificationListingPage(
            controller: context.read<VerificationBloc>().notesController,
            forceOnChanged: (){},
            approveOnTap: (){},
            rejectOnTap: (){},
            checkList: context.read<VerificationBloc>().addressCheckList,
            attachments: context.read<VerificationBloc>().addressAttachments,
          );
        });
  }
}
