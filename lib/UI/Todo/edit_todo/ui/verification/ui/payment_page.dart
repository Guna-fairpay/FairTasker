part of 'verification_main_ui.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        var days = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['fullDays'] ?? '';
        var pricePerDay = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['pricePerDay'] ?? '';
        var initialPayment = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['initialPayment'];
        var securityDeposit = List.from(context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['feeTypes'] ?? []).firstOrNull?['amount'] ?? '';
        var subTotal = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['subTotal'] ?? '';
        var initialRentalCost = context.read<VerificationBloc>().model?['bookingDetails']?['cost_summary']?['initialRentalCost'] ?? '';

        return Column(
          children: [
           ExpansionTile(
             key: const PageStorageKey<String>("breakdown"),
               title: const Row(
                 spacing: 10,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   FittedBox(child: CompactText('Upfront & Breakdown', fontWeight: FontWeight.bold,)),
                   FittedBox(child: CompactText('case app', fontWeight: FontWeight.bold,)),
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
            Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  Column(
                    children: [

                    ],
                  ),
                  Column(
                    children: [],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
