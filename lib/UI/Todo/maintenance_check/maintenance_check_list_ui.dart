import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_bloc.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_events.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_states.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/components/maintenance_check_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintenanceCheckListUi extends StatelessWidget {
  const MaintenanceCheckListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceCheckBloc, MaintenanceCheckState>(
        builder: (context, state) => ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: context
                  .watch<MaintenanceCheckBloc>()
                  .maintenanceCheckList
                  .length,
              itemBuilder: (BuildContext context, int index) {
                var model = context
                    .watch<MaintenanceCheckBloc>()
                    .maintenanceCheckList[index];
                return MaintenanceCheckListItem(
                  model: model,
                  onCreateTask: (value) => context
                      .read<MaintenanceCheckBloc>()
                      .add(MaintenanceCreateTaskEvent(value)),
                  onCheckChanged: (e, value) => context
                      .read<MaintenanceCheckBloc>()
                      .add(MaintenanceCheckItemCheckEvent(e, value)),
                  onDropDownChanged: (e, value) => context
                      .read<MaintenanceCheckBloc>()
                      .add(MaintenanceChangeStatusEvent(e, value)),
                );
              },
            ));
  }
}
