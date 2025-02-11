import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
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
  TextEditingController unStartTimeController = TextEditingController();
  TextEditingController unEndTimeController = TextEditingController();
  List<Map<String, dynamic>> leaveType = [];
  dynamic selectedLeaveType;
  bool loading = false;
  List<String> options = ['First Half', 'Second Half'];
  String? currentOption;

  @override
  void initState() {
    super.initState();

    leaveManagementBloc = LeaveManagementBloc();
    startDateController.text = widget.leave['start_date'] ?? '';
    endDateController.text = widget.leave['end_date'] ?? '';
    reasonController.text = widget.leave['reason'] ?? '';
    if (widget.leave['start_time'] != null) {
      startTimeController.text =
          Utils.convertToHourMinutes(widget.leave['start_time'] ?? '');
      unStartTimeController.text =
          Utils.convertToHourMinutes(widget.leave['start_time'] ?? '');
    }
    if (widget.leave['end_time'] != null) {
      endTimeController.text =
          Utils.convertToHourMinutes(widget.leave['end_time'] ?? '');
      unEndTimeController.text =
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
      return '${parts[0]}:${parts[1]}'; // Return only hours and minutes
    }
    return time; // Return as-is if format is unexpected
  }

  void _save() {
    setState(() {
      // isVehicleFieldEmpty=vehicleController.text.isEmpty;
      // isCustomerFieldEmpty=customerController.text.isEmpty;
    });
    if (startDateController.text.isEmpty || startDateController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updatelaves = {
      'start_date': startDateController.text,
      'end_time': endDateController.text,
      'reason': reasonController.text,
      'leave_type': selectedLeaveType ?? '',
    };
    Navigator.pop(context, updatelaves);
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
            loading = true;
          } else if (state is LeaveTypeListLoaded) {
            loading = false;
            leaveType.clear();
            leaveType.addAll(state.data ?? []);
            selectedLeaveType = leaveType.firstWhere(
              (item) => item['name'] == widget.leave['leave_type']['name'],
              orElse: () => {},
            );
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
                  });
                }, labelKey: 'name', initialSelection: selectedLeaveType),
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
                                print(endTimeController.text);
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
                  maxLines: 5,
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
                Visibility(
                  visible: loading,
                  child: Center(child: Utils.getProgressIndicator(context)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
