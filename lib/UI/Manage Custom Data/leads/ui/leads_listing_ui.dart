part of 'leads_main_ui.dart';

class LeadsListingUI extends StatelessWidget {
  const LeadsListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadsBloc, LeadsState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 3,
                  child: DateRangePicker(
                    padding: 5.padding,
                    selectedDateRange: context.read<LeadsBloc>().selectedDateRange,
                    onDateRangeSelected:(range) => context.read<LeadsBloc>().add(DateRangeEvent(range)),
                  ),
                ),
                Expanded(
                  child: SuccessButton(
                    text: 'Export',
                    backgroundColor: AppC.appColor,
                    onPressed: ()=> context.read<LeadsBloc>().add(ExportEvent()),
                  ),
                )
              ],
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border:  const TableBorder(horizontalInside: BorderSide(color: AppC.borderColor, width: Num.borderWidthThinField)),
              children: [
                const TableHeaderRow(labels: ['Customer Name', ''],
                  backgroundColor: AppC.appbgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                ),
                ...context.watch<LeadsBloc>().filteredResponse.map((e) => TableRow(
                  children: [
                    TableRowInkWell(
                      onTap: ()=> context.read<LeadsBloc>().add(EditEvent(e)),
                      child: Padding(
                        padding: 10.padding,
                        child: Text(e['customer_name']),
                      ),
                    ),
                    TableRowInkWell(
                      onTap: ()=> AskPermissionDialog.show(context,
                        title: "Are you sure?",
                        description:
                        "Do you want to delete this lead?",
                        positiveText: "Yes",
                        negativeText: "Cancel",
                        isReasonRequired: false,
                        onPositivePressed: ()=>context.read<LeadsBloc>().add(DeleteEvent(e)),),
                      child:Padding(
                        padding: 10.horizontalPadding,
                        child:  Icon(RemixIcons.delete_bin_line, color: AppC.redAccent, size: 22.spMin),
                      ) ,
                    ),
                  ],
                )),
              ],
            ),
            CompactPagination(
              currentPage: context.watch<LeadsBloc>().currentIndex,
              totalPages: (context.watch<LeadsBloc>().totalCount / context.watch<LeadsBloc>().itemsPerPage).ceil(),
              onPageChanged: (value) => context.read<LeadsBloc>().add(PaginationEvent(value)),
            ),
          ],
        );
      }
    );
  }
}
