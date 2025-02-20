import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../Bloc/leave_management_bloc.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Event/leave_management_event.dart';
import '../../State/leave_management_state.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveManagementEditUI extends StatefulWidget {
  final Map<String, dynamic> leave;

  const LeaveManagementEditUI({super.key, required this.leave});

  @override
  State<LeaveManagementEditUI> createState() => _LeaveManagementEditUIState();
}

class _LeaveManagementEditUIState extends State<LeaveManagementEditUI> {
  late LeaveManagementBloc leaveManagementBloc;
  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List<Map<String, dynamic>> leaveType = [];
  dynamic selectedLeaveType;
  bool isSelected = false;
  List<String> options = ['First Half', 'Second Half'];
  String? currentOption;
  String? leaveDuration;

  @override
  void initState() {
    super.initState();
    print('leave--${widget.leave}');
    leaveManagementBloc = LeaveManagementBloc();
    startDateController.text = widget.leave['start_date'] ?? '';
    endDateController.text = widget.leave['end_date'] ?? '';
    reasonController.text = widget.leave['reason'] ?? '';
    if (widget.leave['start_time'] != null) {
      startTimeController.text =
          Utils.convertToHourMinutes(widget.leave['start_time'] ?? '');
    }
    if (widget.leave['end_time'] != null) {
      endTimeController.text =
          Utils.convertToHourMinutes(widget.leave['end_time'] ?? '');
    }

    if (widget.leave['start_time'] != null) {
      try {
        TimeOfDay startTime = TimeOfDay(
          hour: int.parse(widget.leave['start_time'].split(":")[0]),
          minute: int.parse(widget.leave['start_time'].split(":")[1]),
        );
        TimeOfDay firstHalfEnd = const TimeOfDay(hour: 13, minute: 0);
        if (startTime.hour < firstHalfEnd.hour ||
            (startTime.hour == firstHalfEnd.hour &&
                startTime.minute <= firstHalfEnd.minute)) {
          currentOption = options[0];
        } else {
          currentOption = options[1];
        }
      } catch (e) {
        currentOption = options[0];
      }
    } else {
      currentOption = options[0];
    }
  }

  String formatTime(String time) {
    if (time.isEmpty) return '';
    final parts = time.split(":");
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  void _save() {
    setState(() {});
    if (startDateController.text.isEmpty || startDateController.text.isEmpty) {
      return ;
    }
    leaveDuration = startDateController.text == endDateController.text
        ? 'Single'
        : 'Multi';
    final updateLeave = {
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'start_time':isSelected ? '${startTimeController.text}:00':'',
      'end_time':isSelected ? '${endTimeController.text}:00' : '',
      'reason': reasonController.text,
      'leave_type_id': selectedLeaveType['id'].toString(),
      'leave_duration': leaveDuration.toString(),
      'id': widget.leave['id'].toString(),
    };
    Navigator.pop(context, updateLeave);
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
          child: Utils.getTextFormField(
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
          child: Utils.getTextFormField(
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
      appBar: AppBar(
        title: const Text('Edit Leave'),
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),)
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            leaveManagementBloc..add(const GetLeaveTypeListData()),
        child: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
            listener: (context, state) async {
          if (state is LeaveManagementLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is LeaveTypeListLoaded) {
              leaveType.clear();
              leaveType.addAll(state.data ?? []);
              selectedLeaveType = leaveType.firstWhere(
                (item) => item['name'] == widget.leave['leave_type']['name'],
                orElse: () => {},
              );
              isSelected=(selectedLeaveType['name'] == 'Permission'
                  ||selectedLeaveType['name'] == 'Unavailable');
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: 15.padding,
            child: ListView(
              children: [
                Utils.getText('Leave Type', weight: FontWeight.bold),
                const SizedBox(height: 5),
                Utils.dropdownBox('Select', leaveType, (selectedValue) {
                  setState(() {
                    selectedLeaveType = selectedValue;
                    startTimeController.clear();
                    endTimeController.clear();
                    currentOption = options[0];
                    startTimeController.text = '08:00';
                    endTimeController.text = '13:00';
                    isSelected=(selectedLeaveType['name'] == 'Permission'
                        ||selectedLeaveType['name'] == 'Unavailable');
                  });
                }, labelKey: 'name',
                initialSelection: selectedLeaveType),
                const SizedBox(height: 05),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                          'Start Date', startDateController, () {
                        Utils.datePicker(context, '',
                            initial: DateTime.tryParse(startDateController.text)?? DateTime.now())
                            .then((value) {
                          if (value != null) {
                            startDateController.text =
                                Utils.convertDateToYearMonthDateFormat(
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
                            initial: DateTime.tryParse(endDateController.text)?? DateTime.now())
                            .then((value) {
                          if (value != null) {
                            endDateController.text =
                                Utils.convertDateToYearMonthDateFormat(
                                    value.toString());
                          }
                        });
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 05),
                Column(
                  children: [
                    if (selectedLeaveType != null &&
                        selectedLeaveType['name'] == 'Permission')
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
                    if (selectedLeaveType != null &&
                        (selectedLeaveType['name'] == 'Permission'
                            ||selectedLeaveType['name'] == 'Unavailable'))
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
                Utils.getText('Reason', weight: FontWeight.bold),
                const SizedBox(height: 5),
                Utils.getBorderedMultilineTextField(
                    minLines: 3,
                    maxLines: 5,
                    'Type here...',
                    reasonController,
                    fillColor: AppC.white,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (val)=>val!.isEmpty?'Please enter reason':null,
                    inputAction: TextInputAction.done
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Utils.getElevatedButton(
                      text:  'Submit',
                      bgColor: AppC.green,
                      _save,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
