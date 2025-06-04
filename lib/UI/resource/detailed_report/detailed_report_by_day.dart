part of 'detailed_report_ui.dart';

class DetailedReportByDay extends StatelessWidget {
  const DetailedReportByDay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailedBloc, DetailedState>(builder: (context, state) => (context.watch<DetailedBloc>().taskByDay?.isEmpty ?? false) ? const EmptyWidget(withExpand: false) : ListView.separated(
        itemBuilder: (context, index) => DetailedReportByDayItem(model: context.watch<DetailedBloc>().taskByDay?[index], onReference: (value) => context.read<DetailedBloc>().add(ViewURLEvent(model: value))),
        separatorBuilder: (context, index) => 5.spMin.height,
        itemCount: context.watch<DetailedBloc>().taskByDay?.length ?? 0));
  }
}
