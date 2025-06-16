part of 'role_view_main_ui.dart';

class RoleListUI extends StatelessWidget {
  const RoleListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleViewBloc, RoleViewState>(
      builder: (context, state) {
        return (context.watch<RoleViewBloc>().filteredRolesList.isEmpty && state is! LoadingState)
            ? const Center(child: Text('There are no records to display'))
            : Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(flex: 1),
            1: IntrinsicColumnWidth(flex: 4),
            2: IntrinsicColumnWidth(flex: 1),
          },
          border: const TableBorder(horizontalInside: BorderSide(width: 0.5, color: AppC.borderColor)),
          children: [
             const TableHeaderRow(
                tableDecoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppC.black, width: 0.2)),
                  color: AppC.trans,),
                backgroundColor: AppC.appbgColor,
                labels: ["# ", "Name", "Action"]),
            ...context.watch<RoleViewBloc>().filteredRolesList.map((e) => TableRow(children: [
              TableCell(
                child: Padding(
                  padding: 10.padding,
                  child:Utils.getText(
                      "${((context.watch<RoleViewBloc>().currentIndex != 1) ? (((context.watch<RoleViewBloc>().currentIndex - 1) * context.read<RoleViewBloc>().itemsPerPage) + e['index']) : e['index']) + 1}",color: AppC.appColor),
                ),
              ),
              TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.spMin, vertical: 10.spMin),
                    child: Text("${e['name']}"),
                  )),
                TableCell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.spMin, vertical: 10.spMin),
                      child: Row(
                        children: [
                          CompactIconButton(
                            iconSize: 16.spMin,
                            icon:Icons.edit_outlined,
                            backgroundColor: AppC.appColor,
                            onPressed: () =>context.read<RoleViewBloc>().add(AddEditEvent(data: e, isRoleEdit: true, isUserEdit: false)),
                          ),
                          CompactIconButton(
                            iconSize: 16.spMin,
                            icon:Icons.delete_outline,
                            backgroundColor: AppC.redAccent,
                            onPressed: (){
                              AskPermissionDialog.show(context,
                                  title: "Are you sure?",
                                  description: "Do you want to delete this Role?",
                                  positiveText: "Yes, delete it!",
                                  negativeText: "Cancel",
                                  isReasonRequired: false,
                                  onPositivePressed: ()=>context.read<RoleViewBloc>().add(DeleteEvent(e)));
                            },
                          ),
                        ],
                      ),
                    )
                ),
            ])).toList(),
          ],
        );
      }
    );
  }
}
