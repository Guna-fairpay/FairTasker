part of 'approve_task_main_ui.dart';

class ApproveTaskListingUI extends StatelessWidget {
  const ApproveTaskListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApproveTaskBloc, ApproveTaskState>(
      builder: (context, state) => SafeArea(
        minimum: 15.spMin.padding,
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child:
                    DateRangePicker(
                      selectedDateRange: context.watch<ApproveTaskBloc>().selectedDateRange,
                      onDateRangeSelected: (range) => context.read<ApproveTaskBloc>().add(DateRangeEvent(range)),
                      padding: 12.spMin.padding,
                    ),
                  ),
                  Expanded(
                    child:
                    Column(
                      children: [
                        CustomCheckboxListTile(
                          radius: 10,
                            title: const Text("Hide Support"),
                            value:  context.watch<ApproveTaskBloc>().hideSupport,
                            padding: 0.padding,
                            onChanged: (value) => context.read<ApproveTaskBloc>().add(HideSupportEvent())),
                        CustomCheckboxListTile(
                            radius: 10,
                            title: const Text("Extra Hours"),
                            value:  context.watch<ApproveTaskBloc>().extraHours,
                            mainAxisSize: MainAxisSize.min,
                            padding: 0.padding,
                            onChanged: (value) => context.read<ApproveTaskBloc>().add(ExtraHoursEvent())
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<int>(
                    elevation: 3,
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        onTap:()=> context.read<ApproveTaskBloc>().add(TaskInCompletedEvent()),
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              context.read<ApproveTaskBloc>().isTaskIncomplete
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 15,
                              color: context.read<ApproveTaskBloc>().isTaskIncomplete ? Colors.green : Colors.red,
                            ),
                            const Text('Task InCompleted',),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: ()=> context.read<ApproveTaskBloc>().add(OffShorTeamEvent()),
                        value: 2,
                        child: Row(
                          children: [
                            Icon(
                              context.read<ApproveTaskBloc>().isOffShorTeam
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 15,
                              color: context.read<ApproveTaskBloc>().isOffShorTeam ? Colors.green : Colors.red,
                            ),
                            const Text('Offshore Team',),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      color: AppC.appColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(),
                  padding: 5.spMin.verticalPadding,
                  itemCount: context.watch<ApproveTaskBloc>().filterResponse?.length ?? 0,
                  itemBuilder: (context, index) {
                    var item = context.watch<ApproveTaskBloc>().filterResponse?[index];
                    var vehicleName = List.from(item?['vehicleList'] ?? []).length <= 1 ? (List.from(item?['vehicleList'] ?? []).firstOrNull?['vehicle_name']) : 'MV';
                    var userList = List.from(item?['users'] ?? [])
                        .map((e) => [e['first_name'].toString(), e['last_name'].toString()]
                        .toInitial)
                        .toList();
                    bool isRentalStatus = List.from(item?['vehicleList'] ?? []).length == 1
                        ? (List.from(item?['vehicleList'] ?? []).firstOrNull?['rental_status']) == 3
                        ? true : false
                        : false;
                    Color color = (item['complete_time_approved'] == 0) && (item?['extraMin'] != null) ? AppC.redAccent : AppC.appColor;
                    return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: item?['title']),
                                  if(item?['complete_time_taken'] != null)
                                  TextSpan(text: ' (${item?['complete_time_taken']})'),
                                ],
                                    style: TextStyle( color: color, fontWeight: FontWeight.bold))
                            ),
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: vehicleName, style: TextStyle( color: AppC.text, fontWeight: (vehicleName == 'MV') ? FontWeight.bold : FontWeight.normal)),
                                  if(isRentalStatus)
                                    const TextSpan(text: ' (P)', style: TextStyle(color: Color(0xFFFFCC99), fontWeight: FontWeight.bold)),
                                ],
                                )
                            ),
                            if(item?['extraMin'] != null)
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(text: item?['extraMin'], style: const TextStyle(color: AppC.redAccent, fontWeight: FontWeight.bold)),
                                if(item?['notes_complete'] != null)
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()..onTap = () => NotesDialog.show(context, message: item?['notes_complete']),
                                      text: ' - ${item?['notes_complete']}',
                                      style: const TextStyle(color: AppC.text, fontWeight: FontWeight.bold,)),
                              ],),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: item['todo_date'].toString().toDateTime()?.toFormat(format: 'MM-dd') ?? '',
                                  ),
                                  WidgetSpan(child: 5.spMin.width),
                                  TextSpan(text: item?['todo_time'].toString().toFormat(inputFormat: "HH:mm:ss", format: "hh:mm a") ?? ''),
                                ],
                                    style: TextStyle( color: color))
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: 10.horizontalPadding,
                                    child: Utils.getText(userList.join(', '), size: 12.spMin, weight: FontWeight.bold, overFlow: TextOverflow.ellipsis),
                                  ),
                                ),
                                FittedBox(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(14.spMin),
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      side: const BorderSide(width: 0.8, color: AppC.appColor),
                                      activeColor: AppC.appColor,
                                      value: (item['complete_time_approved'] == 1),
                                      onChanged: (v)=> context.read<ApproveTaskBloc>().add(ListCheckEvent(data: item, isApproved: v)),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                    },
                ),
              )
            ],
          ),
      ),
    );
  }
}
