import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_job_params.dart';
import 'package:fairpytasker/Repository/job_list_repository.dart';
import 'package:fairpytasker/Bloc/upcoming_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/time_picker.dart';

class CreateJobUI extends StatefulWidget {
  final Map<String, dynamic>? taskItem;
  const CreateJobUI({Key? key, this.taskItem}) : super(key: key);

  @override
  State<CreateJobUI> createState() => _CreateJobUIState();
}

class _CreateJobUIState extends State<CreateJobUI> {
  UpcomingTaskBloc? upcomingTaskBloc;
  Map<String, dynamic>? taskItem;
  @override
  void initState() {
    upcomingTaskBloc = UpcomingTaskBloc();
    if (widget.taskItem != null) {
      taskItem = widget.taskItem;
      selectedPriority = taskItem!['priority'];
      taskNameController.text = taskItem!['task_name']!;
      taskDateController.text = taskItem!['task_date']!;
      debugPrint('taskItem!.taskDate!: ${taskItem!['task_date']!}');
      debugPrint('taskItem!.duration!: ${taskItem!['duration']!}');
      debugPrint('taskItem!.startTime!: ${taskItem!['start_time']!}');
      debugPrint('taskItem!.endTime!: ${taskItem!['end_time']!}');
      jobListRepo.selectedHours = /*'00:30'*/ taskItem!['duration']!;
      // jobListRepo.chosenDateTimeString = taskItem!.startTime!;
      debugPrint('taskItem!.startTime!: ${taskItem!['start_time']!}');
      jobListRepo.chosenDateTimeString = DateFormat("hh:mm a").format(
          DateTime.now().copyWith(
              hour: int.tryParse(taskItem!['start_time']!.split(':')[0]),
              minute: int.tryParse(taskItem!['start_time']!.split(':')[1])));
      jobListRepo.chosenDateTime = /*DateFormat("hh:mm a").format(*/
          (DateTime.now().copyWith(
              hour: int.tryParse(taskItem!['start_time']!.split(':')[0]),
              minute: int.tryParse(taskItem!['start_time']!.split(':')[1])));
      /*DateTime.parse('2023-10-03 ${taskItem!.startTime!}'))*/
      // jobListRepo.endTimeString = taskItem!.endTime!;
      jobListRepo.endTimeString = DateFormat("hh:mm a")
          .format(DateTime.parse('2023-10-03 ${taskItem!['end_time']!}'));
      debugPrint('taskItem!.startTime!: ${jobListRepo.chosenDateTimeString}');
      debugPrint('taskItem!.endTime!: ${jobListRepo.endTimeString}');
      jobListRepo.startTimeTFString = taskItem!['start_time']!;
      jobListRepo.endTimeTFString = taskItem!['end_time']!;
      descriptionController.text = taskItem!['description']!;
    } else {
      selectedPriority = "Select Priority";
      Map<String, dynamic> resource = ({'first_name': 'Assigned To'});
      selectedAssignedTo = resource;
      selectedDate = DateTime.now();
      taskDateController.text =
          Utils.convertDateTimeToTheFormat(selectedDate.toString());
    }
    super.initState();
  }

  TextEditingController taskDateController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  String? selectedPriority;
  Map<String, dynamic>? selectedAssignedTo;
  JobListRepo jobListRepo = JobListRepo();
  List<Map<String, dynamic>> resourceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppC.trans,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.black,
                )),
            title: Utils.getText('Create Task',
                size: 18, weight: FontWeight.w700)),
        body: BlocProvider(
            create: (context) =>
                upcomingTaskBloc!..add(const GetAssignedToList()),
            child: BlocConsumer<UpcomingTaskBloc, UpcomingTaskState>(
                listener: (context, state) async {
              if (state is AssignedToLoaded) {
                resourceList = state.resource ?? [];
                if (taskItem != null) {
                  debugPrint(
                      'taskItem!.assignedTo!: ${taskItem!['assigned_to']!}');
                  for (Map<String, dynamic> resource in resourceList) {
                    debugPrint('taskItem!.resource.id: ${resource['id']}');
                    if (resource['id'].toString().trim() ==
                        taskItem!['assigned_to']!.trim()) {
                      selectedAssignedTo = resource;
                    }
                  }
                }
              } else if (state is CreateJobLoaded) {
                if (state.result != null && state.result!) {
                  taskNameController.clear();
                  descriptionController.clear();
                  taskDateController.clear();
                  jobListRepo.chosenDateTimeString = null;
                  jobListRepo.selectedHours = null;
                  jobListRepo.endTimeString = null;
                  selectedPriority = null;
                  selectedAssignedTo = null;
                  Navigator.of(context).pop(true);
                }
              }
            }, builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Utils.getDropDownSearch(
                              'Select Priority',
                              ['High - On Time', 'Medium', 'Low', 'Feature'],
                              (value) {
                                selectedPriority = value;
                                setState(() {});
                              },
                              selectedPriority,
                              'Priority',
                              (context, value, isSelected) {
                                return Utils.popupDropDownBuilder(label: value);
                              },
                              (context, value) {
                                return Utils.getText(value ?? '');
                              },
                              showSearch: false),
                          const SizedBox(
                            height: 15,
                          ),
                          Utils.getTextFormField(
                              'Task Name', taskNameController,
                              label: Utils.getText('Task Name')),
                          const SizedBox(
                            height: 15,
                          ),
                          Utils.getTextFormField(
                              'Task Date', taskDateController, readOnly: true,
                              onTapCallback: () {
                            Utils.datePicker(context, '').then((value) {
                              selectedDate = value;
                              taskDateController.text =
                                  Utils.convertDateTimeToTheFormat(
                                      value.toString());
                            });
                          }, label: Utils.getText('Task Date')),
                          const SizedBox(
                            height: 15,
                          ),
                          TimePickerView(jobListRepo: jobListRepo),
                          const SizedBox(
                            height: 15,
                          ),
                          Utils.getBorderedMultilineTextField(
                              'Description', descriptionController,
                              fillColor: AppC.trans,
                              label: Utils.getText('Description')),
                          const SizedBox(
                            height: 15,
                          ),
                          Utils.getDropDownSearch(
                              'Assigned To',
                              resourceList,
                              (value) {
                                selectedAssignedTo = value;
                                setState(() {});
                              },
                              selectedAssignedTo,
                              'Assigned To',
                              (context, value, isSelected) {
                                return Utils.popupDropDownBuilder(
                                    label: (value.firstName ?? '') +
                                        ' ' +
                                        (value.lastName ?? ''));
                              },
                              (context, value) {
                                return Utils.getText((value?.firstName ?? '') +
                                    ' ' +
                                    (value?.lastName ?? ''));
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          Utils.getFilledButton('Create Task', () {
                            if (taskNameController.text.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('Task Name'));
                              return;
                            }
                            if (taskDateController.text.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('Task Date'));
                              return;
                            } else if (jobListRepo.chosenDateTimeString ==
                                    null ||
                                jobListRepo.chosenDateTimeString!.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('Start Time'));
                              return;
                            } else if (jobListRepo.selectedHours == null ||
                                jobListRepo.selectedHours!.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('Duration'));
                              return;
                            } else if (jobListRepo.endTimeString == null ||
                                jobListRepo.endTimeString!.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('End Time'));
                              return;
                            } else if (jobListRepo.endTimeString == null ||
                                jobListRepo.endTimeString!.isEmpty) {
                              Utils.showMobileToast(
                                  Str.createTaskAlertText('End Time'));
                              return;
                            } else {
                              CreateJobParams createJobParams = CreateJobParams(
                                  jobId: widget.taskItem != null
                                      ? widget.taskItem!['id']!
                                      : null,
                                  priority: selectedPriority,
                                  taskAssignedTo:
                                      selectedAssignedTo?['id']!.toString(),
                                  taskDate: taskDateController.text,
                                  taskDescription: descriptionController.text,
                                  taskDuration: jobListRepo.selectedHours,
                                  taskEndTime: jobListRepo.endTimeTFString,
                                  taskName: taskNameController.text,
                                  taskStartTime: jobListRepo.startTimeTFString);
                              debugPrint(
                                  'endTimeTFString.startTimeTFString: ${jobListRepo.endTimeTFString} : ${jobListRepo.startTimeTFString}');
                              upcomingTaskBloc!.add(CreateTaskEvent(
                                  createJobParams: createJobParams));
                            }
                          })
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: state is JobListLoading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            })));
  }
}
