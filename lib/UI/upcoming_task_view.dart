// import 'package:calender_picker/calender_picker.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/UI/create_job_ui.dart';
import 'package:fairpytasker/Bloc/upcoming_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class UpcomingTaskView extends StatefulWidget {
  const UpcomingTaskView({Key? key}) : super(key: key);

  @override
  State<UpcomingTaskView> createState() => _UpcomingTaskViewState();
}

class _UpcomingTaskViewState extends State<UpcomingTaskView> {
  UpcomingTaskBloc? upcomingTaskBloc;
  List<Map<String, dynamic>>? taskList = [];
  // List<Tasks> tempTaskList = [];
  DateTime selectedDate = DateTime.now();
  String? formattedDate;
  String? filterDate;
  DatePickerController? datePickerController;

  @override
  void initState() {
    upcomingTaskBloc = UpcomingTaskBloc();
    formattedDate = DateFormat('yyyy-MMM-dd').format(selectedDate);
    filterDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    datePickerController = DatePickerController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datePickerController!.jumpToSelection();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppC.trans,
          title: Utils.getText("Task List", size: 18, weight: FontWeight.w700),
        ),
        body: BlocProvider(
          create: (context) =>
              upcomingTaskBloc!..add(GetJobList(selectedDate: filterDate)),
          child: BlocConsumer<UpcomingTaskBloc, UpcomingTaskState>(
            listener: (context, state) async {
              if (state is JobListLoaded) {
                taskList = [];
                taskList = state.taskList;
                // tempTaskList = state.taskList??[];
                // debugPrint('tempTaskList: ${tempTaskList.length}');
                formattedDate = /*DateTime.parse*/
                    (DateFormat("dd-MMM-yyyy").format(selectedDate));
                filterDate = /*DateTime.parse*/
                    (DateFormat("yyyy-MM-dd").format(selectedDate));
                debugPrint('filterDate: $filterDate');
                /*for (var element in tempTaskList) {
                if(element.taskDate == filterDate) {
                  taskList!.add(element);
                  }
                }*/
                // debugPrint('taskList: ${taskList!.length}');
              } else if (state is DeleteJobLoaded) {
                upcomingTaskBloc!.add(GetJobList(selectedDate: filterDate));
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      // fetchFrom = 0;
                      upcomingTaskBloc!
                          .add(GetJobList(selectedDate: filterDate));
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
/*
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
                                child: Utils.getText(
                                    "Today",
                                    color: AppC.subText,
                                    size: 18
                                ),
                              ),
*/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Utils.getText(formattedDate!,
                                        size: 18, weight: FontWeight.w700),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppC().base),
                                      child: InkWell(
                                          onTap: () async {
                                            datePickerController!
                                                .jumpToSelection();
                                          },
                                          child: const Icon(
                                            Icons.select_all,
                                            color: AppC.white,
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                DatePicker(
                                  DateTime(DateTime.now().year, 01, 01),
                                  controller: datePickerController,
                                  initialSelectedDate: DateTime.now(),
                                  selectionColor: AppC().base,
                                  selectedTextColor: AppC.white,
                                  onDateChange: (date) {
                                    // New date selected
                                    setState(() {
                                      debugPrint('date: $date');
                                      // debugPrint('tempTaskList: ${tempTaskList.length}');
                                      selectedDate = date;
                                      formattedDate = /*DateTime.parse*/
                                          (DateFormat("dd-MMM-yyyy")
                                              .format(date));
                                      filterDate = /*DateTime.parse*/
                                          (DateFormat("yyyy-MM-dd")
                                              .format(date));
                                      upcomingTaskBloc!.add(
                                          GetJobList(selectedDate: filterDate));
                                      debugPrint('filterDate: $filterDate');
                                      /*taskList = [];
                                    for (var element in tempTaskList) {
                                    if(element.taskDate == filterDate) {
                                    taskList!.add(element);
                                    }
                                    }*/
                                      // debugPrint('taskList: ${taskList!.length}');
                                    });
                                  },
                                ),

                                /*CalenderPicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now(),
                                selectionColor: AppC().bottomIconColor,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  // New date selected
                                  setState(() {
                                    debugPrint('date: $date');
                                    // debugPrint('tempTaskList: ${tempTaskList.length}');
                                    selectedDate = date;
                                    formattedDate = */ /*DateTime.parse*/ /*(DateFormat("dd-MMM-yyyy").format(date));
                                    filterDate = */ /*DateTime.parse*/ /*(DateFormat("yyyy-MM-dd").format(date));
                                    upcomingTaskBloc!.add(GetJobList(selectedDate: filterDate));
                                    debugPrint('filterDate: $filterDate');
                                    */ /*taskList = [];
                                    for (var element in tempTaskList) {
                                      if(element.taskDate == filterDate) {
                                        taskList!.add(element);
                                      }
                                    }*/ /*
                                    debugPrint('taskList: ${taskList!.length}');
                                  });
                                },
                              ),*/
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.getText("Schedule",
                                      size: 18, weight: FontWeight.w500),
                                  Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: AppC().base),
                                        child: InkWell(
                                            onTap: () async {
                                              filterDate = /*DateTime.parse*/
                                                  (DateFormat("yyyy-MM-dd")
                                                      .format(selectedDate));
                                              debugPrint(
                                                  'filterDate: $filterDate');
                                              upcomingTaskBloc!.add(GetJobList(
                                                  selectedDate: filterDate));
                                            },
                                            child: const Icon(
                                              Icons.refresh,
                                              color: AppC.white,
                                            )),
                                      ),
                                      const SizedBox(width: 15),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: AppC().base),
                                        child: InkWell(
                                            onTap: () async {
                                              bool? result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreateJobUI(),
                                                ),
                                              );
                                              if (result != null && result) {
                                                upcomingTaskBloc!.add(
                                                    GetJobList(
                                                        selectedDate:
                                                            filterDate));
                                              }
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: AppC.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: taskList != null && taskList!.isNotEmpty,
                              replacement:
                                  Utils.getEmptyTextWidget(topPadding: 30),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: taskList?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: AppC.containerTextB
                                                    .withOpacity(0.2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 7,
                                                        child: Utils.getText(
                                                            '${taskList?[index]['priority'] ?? 'n/a'} Priority ${taskList?[index]['task_name'] ?? 'n/a'}' /* By ${taskList?[index].assignedTo??'n/a'}*/,
                                                            color: AppC()
                                                                .bottomIconColor),
                                                      ),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Utils.getText(
                                                              taskList?[index][
                                                                      'status'] ??
                                                                  'n/a',
                                                              align:
                                                                  TextAlign.end,
                                                              color: AppC()
                                                                  .bottomIconColor))
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 7,
                                                        child: Utils.getText(
                                                          '${taskList?[index]['task_date'] ?? 'n/a'} | ${taskList?[index]['start_time'] ?? 'n/a'} - ${taskList?[index]['end_time'] ?? 'n/a'}',
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Utils.getText(
                                                            '${taskList?[index]['create_by']?.firstName ?? 'n/a'} ${taskList?[index]['create_by']?.lastName ?? 'n/a'}',
                                                            align:
                                                                TextAlign.end),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: SizedBox(
                                                              height: 30,
                                                              child: Utils
                                                                  .getOutlinedButton(
                                                                      'Edit',
                                                                      () async {
                                                                bool? result =
                                                                    await Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CreateJobUI(
                                                                            taskItem:
                                                                                taskList?[index]),
                                                                  ),
                                                                );
                                                                if (result !=
                                                                        null &&
                                                                    result) {
                                                                  upcomingTaskBloc!.add(
                                                                      GetJobList(
                                                                          selectedDate:
                                                                              filterDate));
                                                                }
                                                              },
                                                                      verticalPadding:
                                                                          0))),
                                                      const SizedBox(width: 20),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 32,
                                                          child: Utils
                                                              .getOutlinedButton(
                                                                  'Delete', () {
                                                            upcomingTaskBloc!.add(
                                                                DeleteJobEvent(
                                                                    taskId: taskList?[index]
                                                                            [
                                                                            'id']
                                                                        .toString()));
                                                          }, verticalPadding: 0),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: state is JobListLoading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            },
          ),
        ));
  }
}
