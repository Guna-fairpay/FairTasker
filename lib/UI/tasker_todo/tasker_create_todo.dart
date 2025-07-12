import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/compact_lead_channel_field.dart';
import 'package:fairpytasker/Component/compact_task_identifier.dart';
import 'package:fairpytasker/Component/compact_task_manager.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/custom_weekdays_gridview.dart';
import 'package:fairpytasker/Component/page_keep_aliver.dart';
import 'package:fairpytasker/Component/scaffold_wrapper.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/ui/leads_main_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_end_after_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_monthly_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_yearly_field.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/UI/dialog/oil_change_exist_dialog.dart';
import 'package:fairpytasker/UI/dialog/reclean/reclean_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/tasker_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/enums/task_enum.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

part 'body/body_form.dart';
part 'sub_pages/main_form.dart';
part 'sub_pages/task_form.dart';
part 'sub_pages/more_form.dart';
part 'sub_pages/custom_form.dart';
part 'sub_pages/task_time_form.dart';
part 'sub_pages/task_recurring_form.dart';
part 'sub_pages/submit_vehicle_form.dart';
part 'header/header_actions.dart';
part 'listener/todo_listener.dart';

class TaskerAddToDo extends StatelessWidget {
  final TaskType taskType;
  final DateTime? selectedDate;
  final dynamic selectedVPerson;
  final bool isNextTask, showHeader;
  final dynamic leadId;
  const TaskerAddToDo({super.key, this.taskType = TaskType.rental, this.isNextTask = false, this.showHeader = true, this.selectedDate, this.selectedVPerson, this.leadId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AddToDoBloc()..add(InitialEvent(taskType: taskType, isNextTask: isNextTask, selectedDate: selectedDate, selectedVPerson: selectedVPerson, showAppBar: showHeader, leadId: leadId)),
    child: BlocListener<AddToDoBloc, AddToDoState>(
      listener: _listenNavigation,
      child: ScaffoldWrapper(
        withScaffold: !isNextTask,
        appBar: CompactAppBar(
          foregroundColour: Colors.white,
          titleWidget: const CompactText("Add Todo", color: Colors.white, fontWeight: FontWeight.bold, overflow: TextOverflow.visible, styleType: TextStyleType.titleMedium),
          automaticallyImplyleading: false,
          actionWidgets: const [ HeaderActions() ],
        ),
        body: SafeArea(
          top: true,
          minimum: 16.spMin.padding,
          child: ListView(
            shrinkWrap: !showHeader,
            physics: ((showHeader) ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics()),
            children: const [ BodyForm() ],
          ),
        ),
      ),
    ),);
  }
}