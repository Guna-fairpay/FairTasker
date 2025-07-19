part of'edit_todo_ui.dart';

class EditTodoBody extends StatelessWidget {
  const EditTodoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
        builder: (context, state) => Form(
            child: ListView(
              shrinkWrap: true, 
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    CustomDateTimePicker<DateTime>(
                      controller: context.read<EditToDoBloc>().dateController,
                      format: "MM-dd-yyyy", 
                      suffixIcon: Icon(Icons.calendar_month_rounded, size: 15.spMin, color: context.theme.hintColor),
                      textAlign: TextAlign.center,
                      value: state.selectedDate,
                      onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoDateChangeEvent(value)),
                    ),
                    // 10.width,
                    CustomDateTimePicker<TimeOfDay>(
                      controller: context.read<EditToDoBloc>().timeController,
                      value: state.selectedTime,
                      use24HourFormat: true,
                      format: "HH:mm",
                      suffixIcon: Icon(Icons.access_time_rounded, size: 15.spMin, color: context.theme.hintColor),
                      onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoTimeChangeEvent(value)),
                    ),
                    Expanded(
                      child: CustomCheckboxListTile(
                        mainAxisSize: MainAxisSize.min,
                        useExpand: true,
                        padding: 0.padding,
                        title: Utils.getText('Time Sensitive', weight: FontWeight.bold,overFlow: TextOverflow.visible,size: 12.spMin),
                        value: state.isTimeSensitive,
                        activeColor: AppC.grey,
                        onChanged: (value) => context.read<EditToDoBloc>().add(EditToDoTimeSensitiveEvent()),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTapDown:  (getIt<CommonService>().departmentId == 9) ? null : (TapDownDetails details) {
                            ResourceSelection.showResourceSelection(
                              context:  context,
                              details:  details,
                              resourceList:  state.resources,
                              selectedValues:  state.selectedResource,
                              onSelectionChanged: (value, name) => context.read<EditToDoBloc>().add(UserSelectionEvent(selectedResource: value, resourceName: name),
                              ),
                            );},
                          child: Utils.getText(
                              state.resourceName.length > 1
                                  ? state.resourceName.join(',\n')
                                  : state.resourceName.join(', '),
                              weight: FontWeight.bold,
                              color: AppC.appColor),
                        ),
                      ],
                    ),
                  ],
                ),
                if(context.watch<EditToDoBloc>().reason != null)...[
                  Utils.getText("Reason : ${context.watch<EditToDoBloc>().reason ?? ''}",size: 10.spMin,overFlow: TextOverflow.visible,color: AppC.grey),
                ],
                10.height,
                SearchViewField(
                  controller: context.read<EditToDoBloc>().taskNameController,
                  suggestions: context.watch<EditToDoBloc>().tasks,
                  itemAsString: (item) => item['task'] ?? '',
                  onSelected: (value) => context.read<EditToDoBloc>().add(EditToDoTaskEvent(selectedTask: value)),
                  selectedItem: (state.selectedTask.isEmpty) ? null : state.selectedTask,
                  onEmptyTap: () => context.push(TaskMainPage(title: context.read<EditToDoBloc>().taskNameController.text,)),
                  showEmpty: true,
                  labelText: 'Task Name',
                  hintText: "Select Task",
                  showTaskType: true,
                ),
                10.height,
                if(context.watch<EditToDoBloc>().showLead)...[
                  SearchViewField(
                    controller: context.read<EditToDoBloc>().leadsController,
                    suggestions: context.watch<EditToDoBloc>().leadChannels,
                    itemAsString: (item) => item['name'] ?? '',
                    onSelected: (value) => context.read<EditToDoBloc>().add(LeadsEvent(value)),
                    selectedItem: (context.watch<EditToDoBloc>().selectedLead != null) ? null : context.watch<EditToDoBloc>().selectedLead,
                    onEmptyTap: () => context.push(LeadsMainUI(customerName: context.read<EditToDoBloc>().leadsController.text,)),
                    showEmpty: true,
                    alwayShowSuffix: true,
                    labelText: 'Lead/Channel',
                    hintText: "Select Lead",
                  ),
                  10.height,
                ],
                if((!Str.checkInCheckOut.contains(state.apiResponse['title']) && state.selectedTask['user_type'] != 5))...[
                  CustomVehiclePersonField(
                    vehiclesList: context.watch<EditToDoBloc>().vehicles,
                    personsList: context.watch<EditToDoBloc>().persons,
                    groupVehicles: context.watch<EditToDoBloc>().groupVehicleList,
                    selected: state.selectedVPerson,
                    onDeleted: (val)=> context.read<EditToDoBloc>().add(EditToDoDeleteVehicleEvent(data: val)),
                    onSelected: (val) => context.read<EditToDoBloc>().add(EditToDoVPersonEvent(val)),
                    controller: context.read<EditToDoBloc>().vPersonController,
                  ),
                  10.height,
                ],
                if((!Str.checkInCheckOut.contains(state.apiResponse['title']) && (!Str.userTypeId.contains(state.selectedTask['user_type']))) && (state.apiResponse['lead_id'] == null && state.apiResponse['channel_id'] == null))...[
                  CustomVendorLocationField(
                    vendorsList: context.watch<EditToDoBloc>().vendor,
                    locationsList: context.watch<EditToDoBloc>().location,
                    selected: {3: state.selectedVLocations},
                    onSelected: (val) => context.read<EditToDoBloc>().add(EditToDoVLocationEvent(val)),
                    controller: context.read<EditToDoBloc>().vLocationController,
                  ),
                  10.height,
                ],
                if(state.selectedTask['user_type'] == 5)...[
                  Utils.dropdownBox(
                      'Select Mode',
                      context.read<EditToDoBloc>().meetingType,
                          (value) => context.read<EditToDoBloc>().add(EditToDoMeetingTypeEvent(value)),
                      initialSelection: context.watch<EditToDoBloc>().selectedMeetingType,
                      labelKey: 'name'
                  ),
                  10.height,
                  if(context.watch<EditToDoBloc>().selectedMeetingType?['id'] == 1)...[
                    Utils.getTextFormField(
                      'Meeting Link',
                      context.read<EditToDoBloc>().meetingLinkController,
                      isDense: true,
                      contentPadding: 10.padding,
                      labelStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
                      style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                    ),
                    10.height,
                  ],
                  Utils.dropdownBox(
                      '',
                      context.read<EditToDoBloc>().meetingTime,
                    (v) => context.read<EditToDoBloc>().add(MeetingTimeEvent(v)),
                      labelKey: 'name',
                    initialSelection: context.watch<EditToDoBloc>().selectedMeetingTime,
                  ),
                  10.height,
                ],
                Utils.getTextFormField(
                  'Notes',
                  context.read<EditToDoBloc>().notesController,
                  isDense: true,
                  contentPadding: 10.padding,
                  labelStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                ),
                10.height,
                if(state.selectedTask['id'] == 358)...[
                  CustomQuillEditor(controller: context.read<EditToDoBloc>().quillController,),
                  10.height,
                ],
                if(state.apiResponse['maintenance_task_id'] != null && state.apiResponse['comments'] != null)...[
                  Utils.getTextFormField(
                    'Comments', context.read<EditToDoBloc>().commentsController,
                    isDense: true,
                    contentPadding: 10.padding,
                    labelStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
                    style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                    minLines: 3,
                    maxLines: 3,
                  ),
                  10.height,
                ],
                if((state.apiResponse['title']).toString().toLowerCase().contains('fix'))...[
                  Utils.getTextFormField(
                      'Resolution Notes',
                      context.read<EditToDoBloc>().resolutionNotesController,
                      isDense: true,
                      contentPadding: 10.padding,
                      labelStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
                      style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                      readOnly: false,
                      onChangeCallback: (value) {}
                  ),
                  10.height,
                ],
                if(!Str.checkInCheckOut.contains(state.apiResponse['title']) && (!Str.userTypeId.contains(state.selectedTask['user_type'])) && (state.apiResponse['lead_id'] == null && state.apiResponse['channel_id'] == null))...[
                  const EditTodoMoreForm(),
                  10.height,
                ],
                const EditTodoUpdateButton(),
                10.height,
                if (state.apiResponse.isNotEmpty)
                  const PageKeepAliver(
                      key:PageStorageKey("EditTodoBottomTabs"),
                      child: EditTodoBottomTabs()),
              ],
            )
        )
    );
  }


}
