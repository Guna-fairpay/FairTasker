part of 'vehicle_add_edit_main_ui.dart';

class VehicleAddEditListingUI extends StatelessWidget {
  const VehicleAddEditListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleAddEditBloc, VehicleAddEditState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CompactAppBar(
            titleText: context.read<VehicleAddEditBloc>().isEdit
                ? context.read<VehicleAddEditBloc>().editModel?['vehicle']?['vehicle_name']
                : 'Add Expense',
            foregroundColour: AppC.white, 
            onClose: context.pop, 
            actionWidgets: [(context.read<VehicleAddEditBloc>().isEdit)
                ? IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent),
              onPressed: (){
                AskPermissionDialog.show(context,
                    title: "Are you sure?",
                    description: "Do you want to delete this Expense?",
                    positiveText: "Yes, delete it!",
                    negativeText: "Cancel",
                    isReasonRequired: false,
                    onPositivePressed: () => context.read<VehicleAddEditBloc>().add(DeleteEvent()));
                },
            ) : const SizedBox.shrink(),
              IconButton(
                icon: const Icon(Icons.close, color: AppC.white),
                onPressed: ()=> context.pop(),
              )
            ],
          ),
          body: SafeArea(
            minimum: 15.spMin.padding,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children:  [
                const VehicleAddEditFormFieldUI(),
                if(context.watch<VehicleAddEditBloc>().todoItems != null && context.watch<VehicleAddEditBloc>().isEdit)...[
                  10.spMin.height,
                const VehicleTodoDetailsUI(),
                ],
                if(context.watch<VehicleAddEditBloc>().splitExpense.isNotEmpty && context.watch<VehicleAddEditBloc>().isEdit)...[
                  10.spMin.height,
                const VehicleSplitExpenseUI(),
                ]
              ],
            ),
          ),
        );
      }
    );
  }
}
