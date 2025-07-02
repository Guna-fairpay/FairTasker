part of 'revenue_main_ui.dart';

class RevenueListing extends StatelessWidget {
  const RevenueListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueBloc, RevenueState>(builder: (context, state) => Expanded(
      child: Skeletonizer(
        enabled: state is LoadingState,
        child: ListView.separated(
            itemBuilder: (context, index) => RevenueListItem(model: context.watch<RevenueBloc>().filteredApiResponse[index], isLoading: state is LoadingState,),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: context.watch<RevenueBloc>().filteredApiResponse.length),
      ),
    ));
  }
}
