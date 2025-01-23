import 'package:flutter/material.dart';
import '../Component/drawer_ui.dart';
import '../Component/header.dart';
import '../Utilities/appC.dart';
import '../Utilities/utils.dart';
import 'package:intl/intl.dart';

class RecurrenceTask extends StatefulWidget {
  const RecurrenceTask({super.key});

  @override
  State<RecurrenceTask> createState() => _RecurrenceTaskState();
}

class _RecurrenceTaskState extends State<RecurrenceTask> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController weekController = TextEditingController();
  TextEditingController yearDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noOccurrencesController = TextEditingController();
  TextEditingController monthDayController = TextEditingController();
  TextEditingController firstLastController = TextEditingController();

  bool _isEndAfter = false;
  bool _isMonth = false;
  List<String> priority = ['High-OnTime', 'Medium', 'Low', 'Feature'];
  String? selectPriority = 'Medium';

  List<String> assignedTo = [
    'Product Owner',
    'Hasnath Mohammed',
    'Inshaf Nazir',
    'Abdullah Khan',
    'Zohaib Ahmed',
    'Mudassir Iqbal',
    'Lingeshwaran T',
    'Mukesh N',
    'Suhaina Begum',
    'Imthiyaas Ahamed'
  ];
  String? selectAssignedTo = 'Product Owner';
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String? selectMonth = 'January';
  List<String> selectedAssignedTo = [];
  String? selectedFrequency;
  List<String> selectedDays = [];
  static const String Daily = 'Daily';
  static const String Weekly = 'Weekly';
  static const String Monthly = 'Monthly';
  static const String Yearly = 'Yearly';
  bool isselected = false;

  List<String> duration = [
    '00:00',
    '00:15',
    '00:30',
    '00:45',
    '01:00',
    '01:15',
    '01:30',
    '01:45',
    '02:00',
    '02:15',
    '02:30',
    '02:45',
    '03:00',
    '03:15',
    '03:30',
    '03:45',
    '04:00',
    '04:15',
    '04:30',
  ];
  String? selectduration = '00:00';

  @override
  void initState() {
    super.initState();
    selectedFrequency = Daily;
    startTimeController.addListener(_updateEndTime);
  }

  void _onPriorityChanged(String? value) {
    setState(() {
      selectPriority = value;
    });
  }

  void _onAssignedToChanged(value) {
    setState(() {
      selectAssignedTo = value;
    });
  }

  void _onMonthToChanged(value) {
    setState(() {
      selectMonth = value;
    });
  }

  void _onFrequencyChanged(String frequency) {
    setState(() {
      selectedFrequency = frequency;
    });
  }

  void _updateEndTime() {
    if (startTimeController.text.isNotEmpty && selectduration != null) {
      final startTime = DateFormat.jm()
          .parse(startTimeController.text); // Parse the start time
      final durationParts = selectduration!.split(':');
      final hours = int.parse(durationParts[0]);
      final minutes = int.parse(durationParts[1]);
      final duration = Duration(hours: hours, minutes: minutes);

      final endTime = startTime.add(duration);
      setState(() {
        endTimeController.text =
            DateFormat.jm().format(endTime); // Format and set end time
      });
    }
  }

  // Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           timePickerTheme: TimePickerThemeData(
  //             backgroundColor: Colors.white, // Background color
  //             hourMinuteTextColor:isselected ? AppC.white: Colors.black, // Color for hour and minute text
  //             dialBackgroundColor: Colors.grey[100], // Dial background color
  //             dialHandColor: Colors.blue[900], // Color of the dial hands
  //             dayPeriodTextColor: Colors.black, // Color of AM/PM text
  //             helpTextStyle: TextStyle(color: Colors.black), // Help text color
  //             dialTextStyle: const TextStyle(color: AppC.appColor, fontSize: 20), // Title text style
  //           ),
  //           // Additional customizations outside of TimePickerThemeData
  //           colorScheme: ColorScheme.light(primary: AppC.appColor), // Button color and other elements
  //         ),
  //         child: child!,
  //       );
  //     },
  //     barrierColor: Colors.black54, // Color of the overlay behind the time picker
  //   );
  //
  //   if (picked != null) {
  //     final formattedTime = picked.format(context);
  //     setState(() {
  //       controller.text = formattedTime;
  //       _updateEndTime(); // Update end time when start time is selected
  //     });
  //   }
  // }
  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    final hours = int.parse(parts[0].trim());
    final minutes = int.parse(parts[1].trim());
    return Duration(hours: hours, minutes: minutes);
  }

  // Update end time based on the selected duration
  void _onDurationChanged(String? newDuration) {
    setState(() {
      selectduration = newDuration;
      if (startTimeController.text.isNotEmpty && selectduration != null) {
        final startTime =
            Utils.convertTimeStringToDateTime(startTimeController.text);
        final duration = _parseDuration(selectduration!);
        final endTime = startTime.add(duration);
        endTimeController.text = Utils.convertDateTimeToTimeString(endTime);
      }
    });
  }

  // Open time picker and update controller
  void _selectTime(BuildContext context, TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white, // Background color
              hourMinuteTextColor: isselected
                  ? AppC.white
                  : Colors.black, // Color for hour and minute text
              dialBackgroundColor: Colors.grey[100], // Dial background color
              dialHandColor: Colors.blue[900], // Color of the dial hands
              dayPeriodTextColor: Colors.black, // Color of AM/PM text
              helpTextStyle:
                  const TextStyle(color: Colors.black), // Help text color
              dialTextStyle: const TextStyle(
                  color: AppC.appColor, fontSize: 20), // Title text style
            ),
            // Additional customizations outside of TimePickerThemeData
            //colorScheme: ColorScheme.light(primary: AppC.appColor), // Button color and other elements
          ),
          child: child!,
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        controller.text = Utils.convertDateTimeToTimeString(selectedDateTime);
        // If endTimeController is empty, recalculate it
        if (endTimeController.text.isEmpty) {
          _onDurationChanged(selectduration);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    Utils.getText('Recurrence Task',
                        size: 20, weight: FontWeight.bold),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Utils.buildDropdownButton(
                  'Priority',
                  priority,
                  selectPriority,
                  _onPriorityChanged,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: Utils.getTextFormField(
                    '',
                    taskNameController,
                    label: Utils.getText('Task Name', color: AppC.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Utils.buildDropdownButton(
                  'Assign To',
                  assignedTo,
                  selectAssignedTo,
                  _onAssignedToChanged,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              '',
                              startTimeController,
                              suffixIcon: const Icon(
                                Icons.access_time_outlined,
                                color: AppC.appColor,
                              ),
                              readOnly: true,
                              onTapCallback: () {
                                _selectTime(context, startTimeController);
                              },
                              label: Utils.getText('Start Time',
                                  color: AppC.grey,
                                  overFlow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Utils.buildDropdownButton(
                          'Duration',
                          duration,
                          selectduration,
                          _onDurationChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              '',
                              endTimeController,
                              suffixIcon: const Icon(
                                Icons.access_time_outlined,
                                color: AppC.appColor,
                              ),
                              readOnly: true,
                              onTapCallback: () {
                                _selectTime(context, endTimeController);
                              },
                              label: Utils.getText(
                                'End Time',
                                color: AppC.grey,
                                overFlow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFrequencyButton('Daily', Daily),
                            const SizedBox(width: 10),
                            _buildFrequencyButton('Weekly', Weekly),
                            const SizedBox(width: 10),
                            _buildFrequencyButton('Monthly', Monthly),
                            const SizedBox(width: 10),
                            _buildFrequencyButton('Yearly', Yearly),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (selectedFrequency != null)
                  if (selectedFrequency == Daily)
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Utils.getText(
                                'Occur every',
                                weight: FontWeight.bold,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Utils
                                      .getTextFormField(
                                    'eg:1,2,3',
                                    dayController,
                                    hintTextColor: AppC.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Utils.getText(
                                  'days',
                                  weight: FontWeight.bold,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            height: 0.5,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                if (selectedFrequency == Weekly)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Utils.getText(
                            'Occur every',
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Utils
                                  .getTextFormField(
                                'eg:1,2,3',
                                weekController,
                                hintTextColor: AppC.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Utils.getText(
                              'weeks',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Checkboxes for each day of the week
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: [
                          _buildDayCheckbox('Mon'),
                          _buildDayCheckbox('Tues'),
                          _buildDayCheckbox('Wed'),
                          _buildDayCheckbox('Thu'),
                          _buildDayCheckbox('Fri'),
                          _buildDayCheckbox('Sat'),
                          _buildDayCheckbox('Sun'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 0.5,
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                if (selectedFrequency == Monthly)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: _isMonth,
                                onChanged: (value) {
                                  setState(() {
                                    _isMonth = value;
                                  });
                                },
                                activeTrackColor: AppC.appColor,
                                activeColor: AppC.white,
                                inactiveTrackColor: AppC.white,
                                inactiveThumbColor: AppC.appColor,
                              ),
                            ),
                            Utils.getText(
                              'Date',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Utils.getText(
                              'Occur',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _isMonth
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Utils
                                              .getTextFormField(
                                            'eg:first,last',
                                            firstLastController,
                                            hintTextColor: AppC.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Add some spacing between the fields
                                        Expanded(
                                          child: Utils
                                              .getTextFormField(
                                            'eg:monday,...',
                                            monthDayController,
                                            hintTextColor: AppC.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Utils
                                      .getTextFormField(
                                      'eg:1,2,3',
                                      monthController,
                                      hintTextColor: AppC.grey,
                                    ),
                            ),
                            const SizedBox(width: 20),
                            Utils.getText(
                              'of every month',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 0.5,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                if (selectedFrequency == Yearly)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Utils.getText(
                              'Date',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: Utils
                                    .getTextFormField(
                                  'date',
                                  yearDateController,
                                  hintTextColor: AppC.grey,
                                  textType: TextInputType.number,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Utils.getText(
                              'Month',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Utils.buildDropdownButton(
                                '',
                                months,
                                selectMonth,
                                _onMonthToChanged,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          height: 0.5,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Utils.getText('Range of recurrence',
                            weight: FontWeight.bold, size: 14),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        Column(
                          children: [
                            Utils.getText('Start at ',
                                weight: FontWeight.bold, size: 14),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Utils
                                    .getTextFormField(
                                  'mm-dd-yyyy',
                                  startDateController,
                                  suffixIcon: const Icon(
                                    Icons.date_range,
                                    color: AppC.appColor,
                                  ),
                                  readOnly: true,
                                  onTapCallback: () {
                                    Utils.datePicker(context, '',
                                            initial:
                                                DateTime.parse("1970-01-01"))
                                        .then((value) {
                                      if (value != null) {
                                        startDateController.text =
                                            Utils.convertDateTimeToTheFormat(
                                                value.toString());
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: _isEndAfter,
                            onChanged: (Value) {
                              setState(() {
                                _isEndAfter = Value;
                              });
                            },
                            activeTrackColor: AppC.appColor,
                            activeColor: AppC.white,
                            inactiveTrackColor: AppC.white,
                            inactiveThumbColor: AppC.appColor,
                          ),
                        ),
                        Column(
                          children: [
                            Utils.getText(_isEndAfter ? 'EndDate' : 'EndAfter',
                                weight: FontWeight.bold, size: 14),

                            ///'Ent Date ',weight: FontWeight.bold,size: 14
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 40,
                                  child: _isEndAfter
                                      ? Utils
                                          .getTextFormField(
                                          'No.of occurrences',
                                          noOccurrencesController,
                                        )
                                      : Utils
                                          .getTextFormField(
                                          'mm-dd-yyyy',
                                          endDateController,
                                          suffixIcon: const Icon(
                                            Icons.date_range,
                                            color: AppC.appColor,
                                          ),
                                          readOnly: true,
                                          onTapCallback: () {
                                            Utils.datePicker(context, '',
                                                    initial: DateTime.parse(
                                                        "1970-01-01"))
                                                .then((value) {
                                              if (value != null) {
                                                endDateController.text = Utils
                                                    .convertDateTimeToTheFormat(
                                                        value.toString());
                                              }
                                            });
                                          },
                                        )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      height: 0.5,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Utils.getAddFilledButton(
                        'Save',
                        () {
                          // _saveParts();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const DrawerView(),
    );
  }

  Widget _buildFrequencyButton(String label, String frequency) {
    return SizedBox(
      height: 40,
      child: Utils.getOutlinedButton(
        label,
        bgColor: selectedFrequency == frequency ? AppC.appColor : AppC.white,
        textColor: selectedFrequency == frequency ? AppC.white : AppC.appColor,
        () => _onFrequencyChanged(frequency),
        verticalPadding: 2,
      ),
    );
  }

  Widget _buildDayCheckbox(String day) {
    return FilterChip(
      backgroundColor: AppC.white,
      selectedColor: Colors.blueAccent,
      selectedShadowColor: Colors.lightBlueAccent,
      label: Text(day),
      selected: selectedDays.contains(day),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            selectedDays.add(day);
          } else {
            selectedDays.remove(day);
          }
        });
      },
    );
  }
}
