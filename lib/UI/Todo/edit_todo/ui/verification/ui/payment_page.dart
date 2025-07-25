part of 'verification_main_ui.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        var days = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['fullDays'] ?? '';
        var pricePerDay = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['pricePerDay'] ?? '';
        var initialPayment = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['initialPayment'] ?? '';
        var securityDeposit = List.from(context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['feeTypes'] ?? []).firstOrNull?['amount'] ?? '';
        var subTotal = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['subTotal'] ?? '';
        var initialRentalCost = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['initialRentalCost'] ?? '';
        var paymentType = context.read<VerificationBloc>().bookingDetails?['payment_request']?['payout_account']?['payment_method'] ?? '';
        List<dynamic> payments = List.from(context.read<VerificationBloc>().bookingDetails?['payments'] ?? []);
        var type = payments.firstOrNull?['payment_type'] ?? '';
        var status = payments.firstOrNull?['status'] ?? '';
        var date = payments.firstOrNull?['created_at'] ?? '';
        var amount = payments.firstOrNull?['amount'] ?? '';
        var transactionNo = payments.firstOrNull?['transaction_no'] ?? '';
        List<dynamic>paymentAttachments = context.read<VerificationBloc>().paymentAttachments;

        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(context.read<VerificationBloc>().bookingDetails['payment_status'] == "pending")
                const CompactText('Payment status is pending.\n\nPlease wait for the payment process to be initiated.'),

            if(context.read<VerificationBloc>().bookingDetails['payment_status'] == "pending_request")...[
              List.from(context.read<VerificationBloc>().bookingDetails['payments']).isEmpty
                  ? SuccessButton(text: 'Add payment', onPressed: ()=> context.read<VerificationBloc>().add(AddPaymentEvent()),)
                  :const SuccessButton(text: 'Generate',)
            ],
            if(context.read<VerificationBloc>().bookingDetails['payment_status'] == "awaiting_payment")
               SuccessButton(
                text: 'Add payment',
                onPressed: ()=> context.read<VerificationBloc>().add(AddPaymentEvent()),
                backgroundColor: AppC.appColor,),
           ExpansionTile(
             key: const PageStorageKey<String>("breakdown"),
               title:  Row(
                 spacing: 10,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const FittedBox(child: CompactText('Upfront & Breakdown', fontWeight: FontWeight.bold,)),
                   FittedBox(child: CompactText(paymentType, fontWeight: FontWeight.bold,)),
                 ],
               ),
             tilePadding: 0.padding,
             initiallyExpanded: true,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   FittedBox(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         CompactText('Upfront Payment'),
                         CompactText('Security deposit'),
                         CompactText('Subtotal (Additional charges)'),
                         CompactText('Rental cost ($days days @ \$$pricePerDay/day)'),
                       ],
                     ),
                   ),
                   FittedBox(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         CompactText("\$$initialPayment"),
                         CompactText("\$$securityDeposit"),
                         CompactText('\$$subTotal'),
                         CompactText('\$$initialRentalCost'),
                       ],
                     ),
                   ),
                 ],
               )
             ],
           ),
            if(List.from(context.read<VerificationBloc>().bookingDetails?['payments'] ?? []).isNotEmpty)...[
              Container(
                padding: 10.padding,
                width: double.maxFinite,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppC.chipBackgroundUnselected,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CompactText('Type: $type'),
                        CompactText('${date.toString().toFormat(format: 'MM-dd-yyyy', inputFormat: 'yyyy-MM-dd HH:mm')}'),
                        if(transactionNo != null)CompactText("#$transactionNo"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: 2.padding,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: status.toString().status.color,
                          ),
                            child: CompactText(status, color: AppC.white, fontWeight: FontWeight.bold, styleType: TextStyleType.bodySmall,)
                        ),
                        CompactText('\$$amount'),
                        if(paymentAttachments.isNotEmpty) InkWell(
                            onTap: ()=> ImageViewDialog.show(context),
                            child: Icon(Icons.remove_red_eye_outlined, color:AppC.appColor, size: 18.spMin,)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }
    );
  }
}
