part of 'reports_view.dart';

class ReportsViewBody extends StatelessWidget {
  const ReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const Reports(),
          const Tolls(),
          if (getIt<CommonService>().hasFinance) const TaskReport()
        ]);
  }

}
