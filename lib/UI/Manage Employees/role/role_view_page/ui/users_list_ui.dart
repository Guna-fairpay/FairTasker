part of 'role_view_main_ui.dart';

class UsersListUI extends StatelessWidget {
  const UsersListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleViewBloc, RoleViewState>(
        builder: (context, state) {
          return (context.watch<RoleViewBloc>().filteredUsersList.isEmpty && state is! LoadingState)
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
              ...context.watch<RoleViewBloc>().filteredUsersList.map((e) {
                var index = context.watch<RoleViewBloc>().filteredUsersList.indexOf(e);
                var currentIndex = context.watch<RoleViewBloc>().currentIndex;
                return TableRow(children: [
                TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child:Utils.getText(
                        "${((currentIndex != 1) ? (((currentIndex - 1) * context.read<RoleViewBloc>().itemsPerPage) + index) : index) + 1}",color: AppC.appColor),
                  ),
                ),
                TableCell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.spMin, vertical: 10.spMin),
                      child: Text("${e['first_name']} ${e['last_name']}"),
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
                            onPressed: () =>context.read<RoleViewBloc>().add(AddEditEvent(data: e, isRoleEdit: false, isUserEdit: true)),
                          ),
                          if(kDebugMode)
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
              ]);}).toList(),
            ],

          );
        }
    );
  }
}
