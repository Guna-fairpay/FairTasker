part of 'detailed_report_ui.dart';

class DetailedReportBody extends StatelessWidget {
  const DetailedReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailedBloc, DetailedState>(
        builder: (context, state) => Expanded(
                child: AnimatedSwitcher(
              duration: Durations.long4,
              child: switch (context.watch<DetailedBloc>().selectedPageIndex) {
                0 => const DetailedReportByTask(),
                1 => const DetailedReportByDay(),
                _ => Container(),
              },
            )));
  }
}
