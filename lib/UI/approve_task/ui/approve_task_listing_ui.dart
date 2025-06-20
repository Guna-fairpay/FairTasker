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
                  separatorBuilder: (context, index) => Divider(),
                  padding: 5.spMin.verticalPadding,
                  itemCount: 10,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: const TextSpan(children: [
                                  TextSpan(text: 'Move location'),
                                  TextSpan(text: '(00:30)'),
                                ],
                                    style: TextStyle( color: AppC.appColor, fontWeight: FontWeight.bold))
                            ),
                            Utils.getText('2018 NISSAN ROGUE SPORT S (GRAY)', size: 12.spMin),
                            Utils.getText('00:05', size: 12.spMin, color: AppC.redAccent),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                                text: const TextSpan(children: [
                                  TextSpan(text: '05-28'),
                                  TextSpan(text: ' 10:47 AM'),
                                ],
                                    style: TextStyle( color: AppC.appColor))
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: 10.horizontalPadding,
                                  child: Utils.getText('AI ', size: 12.spMin, weight: FontWeight.bold),
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
                                      value: true,
                                      onChanged: (v){},
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
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}
