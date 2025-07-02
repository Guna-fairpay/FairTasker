part of '../ui/revenue_main_ui.dart';

class RevenueListItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  final bool isLoading;
  const RevenueListItem({super.key, this.model, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompactText(model?['vehicle_name'] ?? "", fontWeight: FontWeight.bold, color: AppC.bouncieButtonColor),
          Text.rich(TextSpan(
              children: [
                TextSpan(text: "VID: ${model?['vehicle_id'] ?? ""}, "),
                if ((model?.isEmpty == false) && !isLoading) WidgetSpan(child: Icon(Remix.car_fill, size: 14.spMin, color: AppC.green)),
                TextSpan(text: " ${(model?['vehicle_number'] ?? "")} "),
              ]
          ), style: context.textTheme.labelMedium)
        ],
      ),
      trailing: CompactText("\$${(model?['totalEarnings'] ?? 0).toStringAsFixed(2)}", color: AppC.green, fontWeight: FontWeight.bold),
    );
  }
}
