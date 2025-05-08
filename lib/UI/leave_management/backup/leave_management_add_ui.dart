
import 'package:fairpytasker/Event/leave_management_event.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/leave_management_bloc.dart';
import '../../../State/leave_management_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveManagementAddUI extends StatefulWidget {
  const LeaveManagementAddUI({super.key});

  @override
  State<LeaveManagementAddUI> createState() => _LeaveManagementAddUIState();
}

class _LeaveManagementAddUIState extends State<LeaveManagementAddUI> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final LeaveManagementBloc leaveManagementBloc = LeaveManagementBloc();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController unStartTimeController = TextEditingController();
  TextEditingController unEndTimeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> leaveType = [];
  dynamic selectedLeaveType;
  bool isSelected = false;
  List<String> options = ['First Half', 'Second Half'];
  String? currentOption;

  @override
  void initState() {
    super.initState();

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

    _key.currentState!.validate();
    if (selectedLeaveType == null) {
      return Utils.showMobileToast('Please select a leave type');
    }
    final String leaveDuration = startDateController.text == endDateController.text ?'Single' :'Multi';


    final newLeave = {
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'start_time':isSelected ? startTimeController.text.toDateTime(inputFormat: 'HH:mm')
          .toFormat(format: 'HH:mm:ss')??'':'',
      'end_time':isSelected ? endTimeController.text.toDateTime(inputFormat: 'HH:mm')
          .toFormat(format: 'HH:mm:ss')??'':'',
      'reason': reasonController.text,
      'leave_type_id': selectedLeaveType['id'].toString(),
      'leave_duration': leaveDuration.toString(),
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
          child: Utils.getTextFormField(
            '',
            controller,
            suffixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                Icons.date_range,
                color: AppC.appColor,
              ),
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
            suffixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                Icons.access_time_outlined,
                color: AppC.appColor,
              ),
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
        title: const Text('Apply Leave'),
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
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
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: 15.padding,
            child: Form(
              key: _key,
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
                      print(isSelected);
                    });
                  }, labelKey: 'name'),
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
                  // Visibility(
                  //   visible: loading,
                  //   child: Center(child: Utils.getProgressIndicator(context)),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
