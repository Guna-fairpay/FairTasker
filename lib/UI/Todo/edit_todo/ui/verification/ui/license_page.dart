part of 'verification_main_ui.dart';

class LicensePage extends StatelessWidget {
  const LicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
         return VerificationListingPage(
           controller: context.read<VerificationBloc>().notesController,
           forceOnChanged: (){},
           approveOnTap: (){},
           rejectOnTap: (){},
           checkList: context.read<VerificationBloc>().licenseCheckList,
           attachments: context.read<VerificationBloc>().licenseAttachments,
         );
        });
  }
}
