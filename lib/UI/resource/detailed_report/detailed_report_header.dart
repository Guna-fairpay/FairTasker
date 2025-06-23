part of 'detailed_report_ui.dart';

class DetailedReportHeader extends StatelessWidget {
  const DetailedReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailedBloc, DetailedState>(
        builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: 10.spMin.padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnTile(
                        label: "CheckIn",
                        title: context.watch<DetailedBloc>().selectedModel?['start_time'].toString().toFormat(inputFormat: "HH:mm:ss", format: "hh:mm a") ?? "",
                      ),
                      ColumnTile(
                        label: "CheckOut",
                        title: context.watch<DetailedBloc>().selectedModel?['end_time'].toString().toFormat(inputFormat: "HH:mm:ss", format: "hh:mm a") ?? "",
                      ),
                      ColumnTile(
                        label: "Active Hours",
                        title: context.watch<DetailedBloc>().selectedModel?['activeHour'] ?? "",
                      ),
                      ColumnTile(
                        label: "Total Hours",
                        title: context.watch<DetailedBloc>().selectedModel?['total_hours'].toString().parseDurationToMinutes.minutesToHourMinute ?? "",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: 10.spMin.horizontalPadding,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppC.borderColor,
                                width: Num.borderWidthButton))),
                    child: Row(
                      children: [
                        CustomTabButton(buttonText: "By Task", value: 0, selectedValue: context.watch<DetailedBloc>().selectedPageIndex, onPressed: (val) => context.read<DetailedBloc>().add(ViewByEvent(val))),
                        CustomTabButton(buttonText: "By Day", value: 1, selectedValue: context.watch<DetailedBloc>().selectedPageIndex, onPressed: (val) => context.read<DetailedBloc>().add(ViewByEvent(val))),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}
