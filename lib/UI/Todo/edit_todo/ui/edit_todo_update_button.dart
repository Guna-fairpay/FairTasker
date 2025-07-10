part of 'edit_todo_ui.dart';

class EditTodoUpdateButton extends StatelessWidget {
  const EditTodoUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SuccessButton(text: 'Update',onPressed: () {
                  var currentOdometer = num.tryParse(context.read<EditToDoBloc>().odometerController.text);
                  bool showOdometerPop = (currentOdometer != null && state.showOdometer && (int.tryParse(state.previousOdometer) != 0)
                      && (double.tryParse(currentOdometer.toString()) ?? 0) <
                          (double.tryParse(state.previousOdometer) ?? 0));
                  if(state.apiResponse['recurring_id']!=null){
                    AskPermissionDialog.show(
                      context,
                      title:
                      "Do you want to Update this task only?",
                      description:state.apiResponse['recurring'],
                      positiveText:"Yes, Update it!",
                      negativeText: "Cancel",
                      isReasonRequired: false,
                      subPositiveText:"Update multiple",
                      onSaveMultiPressed: () async {
                        if(state.selectedEndDate != null && state.selectedStartDate != null){
                          await Future.delayed(Durations.short1);
                          AskDateRangePermissionDialog.show(context,
                              endDate: state.selectedEndDate?.toFormat(format: 'yyyy-MM-dd'),
                              startDate: context.read<EditToDoBloc>().recurringStartDate?.toFormat(format: 'yyyy-MM-dd'),
                              selectedEndDate: state.selectedEndDate,
                              selectedStartDate: state.selectedStartDate,
                              onStartDate: (value)=>context.read<EditToDoBloc>().add(EditToDoStartDateChangeEvent(value)),
                              onEndDate: (value)=>context.read<EditToDoBloc>().add(EditToDoEndDateChangeEvent(value)),
                              onPositivePressed: (){
                                if(showOdometerPop){
                                  WarningHelper.odometerWarning(context,
                                      onPositive: () => context.read<EditToDoBloc>().add(
                                          EditToDoSaveEvent()));
                                } else {
                                  context.read<EditToDoBloc>().add(
                                      EditToDoSaveEvent());
                                }
                              }
                          );
                        }
                      },
                      onPositivePressed: (){
                        if(showOdometerPop){
                          WarningHelper.odometerWarning(context,
                              onPositive: () => context.read<EditToDoBloc>().add(
                                  EditToDoSaveEvent()));
                        } else {
                          context.read<EditToDoBloc>().add(
                              EditToDoSaveEvent());
                        }
                      },
                    );
                  }else {
                    if(showOdometerPop){
                      WarningHelper.odometerWarning(context,
                          onPositive: () => context.read<EditToDoBloc>().add(
                              EditToDoSaveEvent()));
                    } else {
                      context.read<EditToDoBloc>().add(
                          EditToDoSaveEvent());
                    }
                  }
                },),
              ],
            ),
            if (state.apiResponse['recurring'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.getText('Recurring Details',
                      color: AppC.appColor, weight: FontWeight.w500),
                  Row(
                    children: [
                      const Icon(Icons.refresh),
                      20.width,
                      Expanded(
                        child:
                        Utils.getText(state.apiResponse['recurring'] ?? ''),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      }
    );
  }
}
