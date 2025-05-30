part of 'project_status_ui.dart';

class ProjectStatusListItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  const ProjectStatusListItem({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    var dateTimer = [(model?['todo_date'].toString().toDateTime().toFormat()), (model?['completed_at'].toString().toDateTime(inputFormat: "yyyy-MM-dd HH:mm:ss").toFormat() ?? "")]..removeWhere((element) => element.toString().isNullOrEmpty);
    var dateTimes = dateTimer.join(" | ");
    return CustomCard(
      color: AppC.redAccent,
      padding: 10.spMin.padding,
      child: Column(
        spacing: 4.0,
        children: [
          RowTile(
            expandTitle: true,
            title: CompactText("${model?['task_name'] ?? ""}"),
            trailing: Label(labelText: (model?['priority'] ?? "").toString().toTitleCase(), backgroundColor: AppC.redAccent, foregroundColor: Colors.white),
          ),
          RowTile(
            expandTitle: true,
            title: CompactText(dateTimes, color: Colors.grey),
            trailing: CompactText("${model?['project']?['name'] ?? ""}", color: AppC.green),
          ),
          LimitedHtmlView(data: model?['comments'], slidingValue: (model?['status'] ?? "0").toString().toNumeric.toDouble())
        ],
      ),
    );
  }
}
