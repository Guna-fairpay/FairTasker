part of 'verification_main_ui.dart';

class TabBarUI extends StatelessWidget {
  const TabBarUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) =>  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            decoration:  const BoxDecoration(
                border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.borderColor))
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  if(context.read<VerificationBloc>().model?['identifier_id'] != 407)...[
                    CustomTabButton(
                    subText: context.watch<VerificationBloc>().model?['bookingDetails']?['license_status'].toString().label,
                    subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['license_status'].toString().type?.color,
                    buttonText: null,
                    icon: Icons.badge_rounded,
                    iconSize: 20.spMin,
                    value: 1,
                    selectedValue: context.watch<VerificationBloc>().selectedValue,
                    onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                    decoration:  BoxDecoration(
                      border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                    ),
                    ),
                    CustomTabButton(
                    subText: context.watch<VerificationBloc>().model?['bookingDetails']?['address_proof_status'].toString().label,
                    subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['address_proof_status'].toString().type?.color,
                    buttonText: null,
                    icon: Icons.home_work_rounded,
                    iconSize: 20.spMin,
                    value: 2,
                    selectedValue: context.watch<VerificationBloc>().selectedValue,
                    onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                    decoration:  BoxDecoration(
                      border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                    ),
                  ),
                  CustomTabButton(
                    subText: context.watch<VerificationBloc>().model?['bookingDetails']?['agreement_status'].toString().label,
                    subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['agreement_status'].toString().type?.color,
                    buttonText: null,
                    icon: Icons.description_rounded,
                    iconSize: 20.spMin,
                    value: 3,
                    selectedValue: context.watch<VerificationBloc>().selectedValue,
                    onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                    decoration:  BoxDecoration(
                      border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                    ),
                  ),
                  CustomTabButton(
                    subText: context.watch<VerificationBloc>().model?['bookingDetails']?['payment_status'].toString().label,
                    subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['payment_status'].toString().type?.color,
                    buttonText: null,
                    icon: Icons.credit_card_rounded,
                    iconSize: 20.spMin,
                    value: 4,
                    selectedValue: context.watch<VerificationBloc>().selectedValue,
                    onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                    decoration:  BoxDecoration(
                      border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                    ),
                  ),
                  CustomTabButton(
                    subText: context.watch<VerificationBloc>().model?['bookingDetails']?['insurance_status'].toString().statusLabel,
                    subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['insurance_status'].toString().statusType?.statusColor,
                    buttonText: null,
                    icon: RemixIcons.contacts_book_2_fill,
                    iconSize: 20.spMin,
                    value: 5,
                    selectedValue: context.watch<VerificationBloc>().selectedValue,
                    onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                    decoration:  BoxDecoration(
                      border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                    ),
                  ),],
                  if(context.read<VerificationBloc>().model?['identifier_id'] == 407)...[
                    CustomTabButton(
                      subText: context.watch<VerificationBloc>().model?['bookingDetails']?['final_agreement_status'].toString().label,
                      subTextColor: context.watch<VerificationBloc>().model?['bookingDetails']?['final_agreement_status'].toString().type?.color,
                      buttonText: 'Final Agreement',
                      value: 6,
                      selectedValue: context.watch<VerificationBloc>().selectedValue,
                      onPressed: (v)=> context.read<VerificationBloc>().add(TabChangeEvent(v)),
                      decoration:  BoxDecoration(
                        border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
          switch(context.watch<VerificationBloc>().selectedValue)
          {
            1 => const LicensePage(),
            2 => const AddressPage(),
            3 => const AgreementPage(),
            4 => const PaymentPage(),
            5 => const InsurancePage(),
            6 => const FinalAgreementPage(),
            _ => const Placeholder(color: Colors.brown,)
          }
        ],
      ));
  }
}
