part of 'detailed_report_ui.dart';

class DetailedReportByDay extends StatelessWidget {
  const DetailedReportByDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => TodoTaskItemCard(model: {}),
        separatorBuilder: (context, index) => 5.spMin.height,
        itemCount: 2));
  }
}
