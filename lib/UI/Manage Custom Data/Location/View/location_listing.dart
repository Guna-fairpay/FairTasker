part of 'location_view.dart';

class LocationListing extends StatelessWidget {
  const LocationListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) => SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.spMin,
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
              columnWidths: const {
                0 : FlexColumnWidth(7),
                1 : IntrinsicColumnWidth(),
                2 : IntrinsicColumnWidth(),
              },
              border: const TableBorder(
                  horizontalInside: BorderSide(
                      width: Num.borderWidthButton,
                      color: AppC.borderColor)),
              children: [
                const TableHeaderRow(
                    labels: ["Location", "", "Actions"],
                    textAlign: TextAlign.end,
                    firstTextAlign: TextAlign.start),
                ...context
                    .watch<LocationBloc>()
                    .filteredResponse
                    .map((e) => LocationListItem(
                  model: e,
                  onEdit: () => context.read<LocationBloc>().add(EnterEditModeEvent(location: e)),
                  onDelete: () {
                    AskPermissionDialog.show(
                      context,
                      title: "Are you sure?",
                      description:
                      "Do you want to delete this location?",
                      positiveText: "Yes, Delete it!",
                      negativeText: "Cancel",
                      isReasonRequired: false,
                      onPositivePressed: () => context.read<LocationBloc>().add(DeleteLocationEvent(e)),
                    );
                  },
                ))
                    .toList(),
              ],
            ),
            CompactPagination(
              currentPage: context.watch<LocationBloc>().currentPage,
              totalPages: context.watch<LocationBloc>().totalPages,
              onPageChanged: (value) => context.read<LocationBloc>().add(PaginationEvent(page: value)),
            )
          ],
        ),
      ),
    );
  }
}
