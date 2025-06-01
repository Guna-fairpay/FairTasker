part of 'detailed_report_ui.dart';

class DetailedReportByTask extends StatelessWidget {
  const DetailedReportByTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.spMin,
      children: [
        ListTile(
          title: CompactText(DateTime.now().toFormat(format: "dd MMM yyyy") ?? ""),
        ),
        Expanded(child: ListView.separated(
            shrinkWrap: true,
            padding: 16.sp.horizontalPadding.copyWith(bottom: 20.sp),
            itemCount: 2,
            separatorBuilder: (context, index) => 10.sp.height,
            itemBuilder: (context, index) => TaskExpansionTile(styleType: TextStyleType.labelLarge)),
        )
      ],
    );
  }
}
