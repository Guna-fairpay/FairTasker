part of 'detailed_report_ui.dart';

class DetailedReportHeader extends StatelessWidget {
  const DetailedReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: 10.spMin.padding,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnTile(
                label: "CheckIn",
                title: "04:17 AM",
              ),
              ColumnTile(
                label: "CheckOut",
                title: "04:16 AM",
              ),
              ColumnTile(
                label: "Active Hours",
                title: "00:30",
              ),
              ColumnTile(
                label: "Total Hours",
                title: "00:00",
              ),
            ],
          ),
        ),
        Padding(
          padding: 10.spMin.horizontalPadding,
          child: Container(
            decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(bottom: const BorderSide(color: AppC.borderColor, width: Num.borderWidthButton))
            ),
            child: const Row(
              children: [
                CustomTabButton(buttonText: "By Task", value: 0, selectedValue: 0),
                CustomTabButton(buttonText: "By Day", value: 1, selectedValue: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
