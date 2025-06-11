part of 'person_view_main_ui.dart';

class PersonViewListingPage extends StatelessWidget {
  const PersonViewListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonViewBloc, PersonViewState>(
      builder: (context, state) {
        return SafeArea(
            minimum: 10.verticalPadding,
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 3,
                      child: DateRangePicker(
                        selectedDateRange: context.read<PersonViewBloc>().selectedDateRange,
                        onDateRangeSelected:(range) => context.read<PersonViewBloc>().add(DateRangeEvent(range)),
                      ),
                    ),
                    CompactIconButton(
                      elevation: 2,
                      icon:Icons.add,
                      iconSize: 18.spMin,
                      backgroundColor: AppC.appColor,
                      onPressed: ()=> context.read<PersonViewBloc>().add(AddEditEvent()),
                      shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    ),
                    30.spMin.width,
                    Utils.getText(
                        'Total: \$${context.read<PersonViewBloc>().totalAmount.toStringAsFixed(2) ?? 0.00}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppC.appColor,)
                    ),
                  ],
                ),
                (context.read<PersonViewBloc>().apiResponse.isEmpty && state is! LoadingState)
                    ? const EmptyWidget() :
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(height: 0.5),
                    itemCount: context.watch<PersonViewBloc>().apiResponse.length,
                    itemBuilder: (context, index) {
                      var data = context.watch<PersonViewBloc>().apiResponse[index];
                      return PersonListItemPage(
                        model: data,
                        onDetailsPage: (v) => context.read<PersonViewBloc>().add(PersonExpenseDetailEvent(model: data)),
                        onChanged: (v) => context.read<PersonViewBloc>().add(ApproveEvent(model: data, approved: v)),
                        onDelete: (v) => context.read<PersonViewBloc>().add(DeleteEvent(model: data)),
                        onEdit: (v) => context.read<PersonViewBloc>().add(AddEditEvent(model: data)),
                      );
                    },
                  ),
                ),
              ],
            ));
      }
    );
  }
}
