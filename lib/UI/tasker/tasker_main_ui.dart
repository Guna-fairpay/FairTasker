import 'package:fairpytasker/UI/dialog/follow_up_task_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/tasker_maintenance_complete_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/tasker_status_todo_complete_dialog.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/tasker_bouncie_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_check_in_out_completed_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_change_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_view_vehicle_history_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_check_pickup_reason_dialog.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_pickup_car_task_dialog.dart';
import 'package:fairpytasker/UI/tasker/task_components/tasker_header.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_address_change_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_completed_time_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog.dart';
import 'package:fairpytasker/UI/tasker/sub_pages/tasker_listing_ui.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog.dart';
import 'package:fairpytasker/UI/tasker_todo/tasker_create_todo.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/edit_todo_ui.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/UI/dialog/show_vehicles_dialog.dart';
import 'package:fairpytasker/UI/dialog/vendor_info_dialog.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fairpytasker/core/app/enums/task_enum.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'helper/tasker_navigation.dart';

class TaskerMainUi extends StatelessWidget {
  const TaskerMainUi({super.key});

  @override
  Widget build(BuildContext _) {
    return BlocProvider<ToDoTaskerBloc>(
      create: (_) => ToDoTaskerBloc()..add(ToDoTaskerInitialEvent()),
      child: const BlocListener<ToDoTaskerBloc, ToDoTaskerState>(
          listener: navigation,
          child: SafeArea(child: Column(children: [TaskerHeader(), TaskerListingUi()]))),
    );
  }
}