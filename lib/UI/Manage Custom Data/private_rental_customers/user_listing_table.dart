part of 'private_rental_customers.dart';

class UserListingTable extends StatelessWidget {
  const UserListingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 16.spMin.topPadding,
      child: Column(
        spacing: 10.spMin,
        mainAxisSize: MainAxisSize.min,
        children: [
          Table(
            children: [
              const TableHeaderRow(labels: ["Name", "Phone", "Rent", "Date", "",], backgroundColor: AppC.appbgColor),
              ...List.generate(5, (index) => const TableChildRow()).toList()
            ],
          ),
          CompactPagination(totalPages: 1, currentPage: 1, onPageChanged: (value) {})
        ],
      ),
    );
  }
}
