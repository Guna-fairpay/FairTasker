import 'package:fairpytasker/Event/leave_management_event.dart';
import 'package:flutter/material.dart';
import '../../Bloc/leave_management_bloc.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../State/leave_management_state.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveManagementAddUI extends StatefulWidget {
  const LeaveManagementAddUI({super.key});

  @override
  State<LeaveManagementAddUI> createState() => _LeaveManagementAddUIState();
}

class _LeaveManagementAddUIState extends State<LeaveManagementAddUI> {
  late LeaveManagementBloc leaveManagementBloc;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController unStartTimeController = TextEditingController();
  TextEditingController unEndTimeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> leaveType = [];
  dynamic selectedLeaveType;
  bool loading = false;
  List<String> options = ['First Half', 'Second Half'];
  String? currentOption;

  @override
  void initState() {
    super.initState();
    leaveManagementBloc = LeaveManagementBloc();
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    endDateController.text = formattedDate;
    startDateController.text = formattedDate;

    String formattedStartTime = '08:00';
    String formattedEndTime = '13:00';

    endTimeController.text = formattedEndTime;
    startTimeController.text = formattedStartTime;
    unEndTimeController.text = formattedEndTime;
    unStartTimeController.text = formattedStartTime;

    currentOption = options[0];
  }

  @override
  void dispose() {
    leaveManagementBloc.close();
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  void _save() {
    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    if (selectedLeaveType == null) {
      return Utils.showMobileToast('Please select a leave type');
    }

    final newLeave = {
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'start_time': startTimeController.text,
      'end_time': endTimeController.text,
      'reason': reasonController.text,
      'leave_type_id': selectedLeaveType['id'].toString(),
    };
    Navigator.pop(context, newLeave);
  }

  Widget _buildDateField(
      String label, TextEditingController controller, Function onTapCallback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.getText(label, weight: FontWeight.bold),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
            '',
            controller,
            suffixIcon: const Icon(
              Icons.date_range,
              color: AppC.appColor,
            ),
            readOnly: true,
            onTapCallback: () {
              onTapCallback();
            },
            label: Utils.getText(label, color: AppC.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(
      String label, TextEditingController controller, Function onTapCallback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.getText(label, weight: FontWeight.bold),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
            '',
            controller,
            suffixIcon: const Icon(
              Icons.access_time_outlined,
              color: AppC.appColor,
            ),
            readOnly: true,
            onTapCallback: () async {
              await onTapCallback();
            },
            label: Utils.getText(label, color: AppC.grey),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Adjust the height
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) =>
            leaveManagementBloc..add(const GetLeaveTypeListData()),
        child: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
            listener: (context, state) async {
          if (state is LeaveManagementLoading) {
            loading = true;
          } else if (state is LeaveTypeListLoaded) {
            loading = false;
            leaveType.clear();
            leaveType.addAll(state.data ?? []);
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                          const SizedBox(
                            width: 10,
                          ),
                          Utils.getText('Apply Leave',
                              size: 20, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 05),
                      Utils.getText('Leave Type', weight: FontWeight.bold),
                      const SizedBox(height: 5),
                      Utils.dropdownBox('Select', leaveType, (selectedValue) {
                        setState(() {
                          selectedLeaveType = selectedValue;
                        });
                      }, labelKey: 'name'),
                      const SizedBox(height: 05),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                                'Start Date', startDateController, () {
                              Utils.datePicker(context, '',
                                      initial: DateTime.parse("2019-01-01"))
                                  .then((value) {
                                if (value != null) {
                                  startDateController.text =
                                      Utils.convertDateTimeToTheFormats(
                                          value.toString());
                                }
                              });
                            }),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: _buildDateField(
                                'End Date', endDateController, () {
                              Utils.datePicker(context, '',
                                      initial: DateTime.parse("2019-01-01"))
                                  .then((value) {
                                if (value != null) {
                                  endDateController.text =
                                      Utils.convertDateTimeToTheFormats(
                                          value.toString());
                                }
                              });
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 05),
                      if (selectedLeaveType != null &&
                          selectedLeaveType['name'] == 'Permission')
                        Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: options[0],
                                    groupValue: currentOption,
                                    onChanged: (value) {
                                      setState(() {
                                        currentOption = value!;
                                        startTimeController.text = '08:00';
                                        endTimeController.text = '13:00';
                                      });
                                    }),
                                Utils.getText('First half',
                                    weight: FontWeight.bold),
                                const SizedBox(
                                  width: 30,
                                ),
                                Radio(
                                    value: options[1],
                                    groupValue: currentOption,
                                    onChanged: (value) {
                                      setState(() {
                                        currentOption = value!;
                                        startTimeController.text = '13:00';
                                        endTimeController.text = '18:00';
                                      });
                                    }),
                                Utils.getText('Second half',
                                    weight: FontWeight.bold),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimeField(
                                      'Start Time', startTimeController,
                                      () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                        hour: int.parse(startTimeController.text
                                            .split(":")[0]),
                                        minute: int.parse(startTimeController
                                            .text
                                            .split(":")[1]),
                                      ),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedTime != null) {
                                      final formattedTime =
                                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                      setState(() {
                                        startTimeController.text =
                                            formattedTime;
                                      });
                                    }
                                  }),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: _buildTimeField(
                                      'End Time', endTimeController, () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                        hour: int.parse(endTimeController.text
                                            .split(":")[0]),
                                        minute: int.parse(endTimeController.text
                                            .split(":")[1]),
                                      ),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedTime != null) {
                                      final formattedTime =
                                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                      setState(() {
                                        endTimeController.text = formattedTime;
                                      });
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 05),
                      if (selectedLeaveType != null &&
                          selectedLeaveType['name'] == 'Unavailable')
                        Row(
                          children: [
                            Expanded(
                                child: _buildTimeField(
                                    'Start Time', unStartTimeController,
                                    () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 8, minute: 0),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                final formattedTime =
                                    '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                unStartTimeController.text = formattedTime;
                              }
                            })),
                            const SizedBox(width: 30),
                            Expanded(
                                child: _buildTimeField(
                                    'End Time', unEndTimeController, () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 13, minute: 0),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                final formattedTime =
                                    '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                unEndTimeController.text = formattedTime;
                              }
                            })),
                          ],
                        ),
                      const SizedBox(height: 05),
                      Utils.getText('Reason', weight: FontWeight.bold),
                      const SizedBox(height: 5),
                      Utils.getBorderedMultilineTextField(
                          minLines: 3,
                          'Reason',
                          reasonController,
                          fillColor: AppC.white,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton(
                              'Submit',
                              bgColor: AppC.green,
                              () {
                                _save();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: loading,
                child: Center(child: Utils.getProgressIndicator(context)),
              ),
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
