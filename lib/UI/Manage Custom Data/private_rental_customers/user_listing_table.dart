part of 'private_rental_customers.dart';

class UserListingTable extends StatelessWidget {
  const UserListingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentalCustomerBloc, State>(builder: (context, state) => Container(
      margin: 16.spMin.topPadding,
      child: Column(
        spacing: 10.spMin,
        mainAxisSize: MainAxisSize.min,
        children: [
          Table(
            border: const TableBorder(horizontalInside: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton)),
            children: [
              const TableHeaderRow(labels: ["Name", "Phone", "Rent", "Date", "",], backgroundColor: AppC.appbgColor),
              ...(context.watch<RentalCustomerBloc>().filteredResponse ?? []).map((e) => TableChildRow(model: e, onEdit: () => context.read<RentalCustomerBloc>().add(EditEvent(e)), onDelete: () => context.read<RentalCustomerBloc>().add(DeleteEvent(e)))).toList()
            ],
          ),
          CompactPagination(totalPages: context.watch<RentalCustomerBloc>().totalPages, currentPage: context.watch<RentalCustomerBloc>().currentPage, onPageChanged: (value) => context.read<RentalCustomerBloc>().add(PaginationEvent(value)))
        ],
      ),
    ));
  }
}
