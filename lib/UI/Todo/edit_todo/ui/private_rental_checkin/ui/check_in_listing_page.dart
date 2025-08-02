part of 'check_in_main_page.dart';

class CheckInListingPage extends StatelessWidget {
  const CheckInListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        return SafeArea(
          minimum: 10.spMin.verticalPadding,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CompactText('Override Security Deposit', fontWeight: FontWeight.bold,),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Utils.getTextFormField(null, hintText: 'Override Security Deposit',TextEditingController())),
                  Expanded(child: Utils.getTextFormField(null, hintText: 'Reason(Optional)', TextEditingController(), maxLines: 2, minLines: 2)),
                  CompactIconButton(icon: RemixIcons.save_2_line, iconSize: 20.spMin, backgroundColor: AppC.green,),
                  ],
              ),
              const CompactText('Odometer', fontWeight: FontWeight.bold),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Utils.getTextFormField(null, TextEditingController())),
                  CompactIconButton(icon: RemixIcons.save_2_line, iconSize: 20.spMin, backgroundColor: AppC.green,),
                ]
              ),
              const CheckInPicturesListUI(),
              SuccessButton(),
            ],
          ),
        );
      }
    );
  }
}
