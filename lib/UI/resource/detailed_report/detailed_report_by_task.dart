part of 'detailed_report_ui.dart';

class DetailedReportByTask extends StatelessWidget {
  const DetailedReportByTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailedBloc, DetailedState>(builder: (context, state) => Column(
      spacing: 5.spMin,
      children: [
        ListTile(
          title: CompactText(context.watch<DetailedBloc>().selectedDate.toFormat(format: "dd MMM yyyy") ?? ""),
          trailing: GestureDetector(
            onTap: () => context.read<DetailedBloc>().add(ViewFilterEvent()),
            child: const Icon(Icons.filter_alt_rounded),
          ),
        ),
        Expanded(child: ListView.separated(
            shrinkWrap: true,
            padding: 16.sp.horizontalPadding.copyWith(bottom: 20.sp),
            itemCount: context.watch<DetailedBloc>().tasks?.length ?? 0,
            separatorBuilder: (context, index) => 10.sp.height,
            itemBuilder: (context, index) => TaskExpansionTile(styleType: TextStyleType.labelLarge, model: context.watch<DetailedBloc>().tasks?[index])),
        )
      ],
    ));
  }
}
