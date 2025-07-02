part of 'task_component_main_page.dart';

class TaskComponentBottomTab extends StatelessWidget {
  const TaskComponentBottomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskComponentBloc, TaskComponentState>(
      builder: (context, state) =>
          Column(
            children: [
              Container(
                decoration:  const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: Num.borderWidthThinField)
                    ),
                ),
                child:  Row(
                  children: [
                    CustomTabButton(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppC.appColor),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                      ),
                        buttonText: 'Task based',
                        value: 0,
                        selectedValue: context.watch<TaskComponentBloc>().selectedTab,
                        onPressed:(val)=> context.read<TaskComponentBloc>().add(TaskComponentTabBarEvent(tabIndex: val))
                    ),
                    CustomTabButton(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppC.appColor),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                        ),
                        buttonText: 'Hourly based',
                        value: 1,
                        selectedValue: context.watch<TaskComponentBloc>().selectedTab,
                        onPressed:(val)=> context.read<TaskComponentBloc>().add(TaskComponentTabBarEvent(tabIndex: val))
                    ),
                  ],
                ),
              ),
              10.spMin.height,
              if(context.read<TaskComponentBloc>().selectedTab == 0)
                const TaskBasedTable(),
              if(context.read<TaskComponentBloc>().selectedTab == 1)
                const HourlyBasedTable(),
            ],
          ),
    );
  }
}
