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
                  Expanded(child: Utils.getTextFormField(null, context.read<CheckInBloc>().securityAmountController, hintText: 'Override Security Deposit')),
                  Expanded(child: Utils.getTextFormField(null, context.read<CheckInBloc>().reasonController, hintText: 'Reason(Optional)', maxLines: 2, minLines: 2)),
                  CompactIconButton(icon: RemixIcons.save_2_line, iconSize: 20.spMin, backgroundColor: AppC.green, onPressed: ()=> context.read<CheckInBloc>().add(SaveDepositEvent()),),
                  ],
              ),
              const CompactText('Odometer', fontWeight: FontWeight.bold),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Utils.getTextFormField(null, context.read<CheckInBloc>().odometerController)),
                  CompactIconButton(icon: RemixIcons.save_2_line, iconSize: 20.spMin, backgroundColor: AppC.green, onPressed: ()=> context.read<CheckInBloc>().add(SaveOdometerEvent()),),
                ]
              ),
              const CheckInPicturesListUI(),
              SuccessButton(
                onPressed: ()=> context.read<CheckInBloc>().add(SaveImagesEvent()),
              ),
            ],
          ),
        );
      }
    );
  }
}
