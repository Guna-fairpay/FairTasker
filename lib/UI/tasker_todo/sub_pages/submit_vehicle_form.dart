part of '../tasker_create_todo.dart';

class SubmitVehicleForm extends StatelessWidget {
  const SubmitVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.spMin,
      children: [
        Row(
          spacing: 10.spMin,
          children: [
            SuccessButton(
                onPressed: () => context.read<AddToDoBloc>().add(SubmitEvent()),
                text: "Save"),
            Expanded(
              child: ((context
                              .watch<AddToDoBloc>()
                              .selectedVPerson
                              .where((element) => ["vehicles", "g_vehicles"]
                                  .contains(element['type']))
                              .lastOrNull !=
                          null) &&
                      !(context.watch<AddToDoBloc>().isNextTask))
                  ? Text(
                      context
                              .watch<AddToDoBloc>()
                              .selectedVPerson
                              .where((element) => ["vehicles", "g_vehicles"]
                                  .contains(element['type']))
                              .lastOrNull?['name'] ??
                          "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppC.black),
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ),
        AnimatedCrossFade(firstChild: PageKeepAliver(
            key: const PageStorageKey("vehicle_history"),
            child: VehicleHistoryViewUI(
                showSameTask: true,
                title: context.watch<AddToDoBloc>().taskName,
                itemPerPage: 5,
                additionalScroll: false,
                showLoading: false,
                vin: context.watch<AddToDoBloc>().lasVehicleVin,
                vehicleName: context.watch<AddToDoBloc>().lasVehicleName,
                groupId: context.watch<AddToDoBloc>().lasVehicleGroupId,
                showHeader: false)), secondChild: const SizedBox.shrink(), crossFadeState: (context.watch<AddToDoBloc>().hasVehicle) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
      ],
    );
  }
}
