import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Repository/job_list_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerView extends StatefulWidget {
  JobListRepo? jobListRepo;
  TimePickerView({super.key, this.jobListRepo});

  @override
  State<TimePickerView> createState() => _TimePickerViewState();
}

class _TimePickerViewState extends State<TimePickerView> {
  /*String? selectedHours;
  String? chosenDateTimeString;
  String endTimeString = "End Time";
*/
  @override
  void initState() {
    if(widget.jobListRepo?.chosenDateTimeString == null){
    widget.jobListRepo?.selectedHours = "Select Duration";
    widget.jobListRepo?.chosenDateTimeString = "Start Time";
    widget.jobListRepo?.endTimeString = "End Time";
    }else{

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 55,
                // width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Num.radiusButton),
                    border:
                    Border.all(color: AppC.fieldBase,
                      width: Num.borderWidthField,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 04),
                  child: InkWell(
                    onTap: () {
                      _showTimePicker(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.jobListRepo?.chosenDateTimeString??'',
                          style: Utils.getTextStyle(
                              color: AppC.subText,
                              weight: FontWeight.w400,
                              size: 15),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppC.fieldBase,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: widget.jobListRepo?.chosenDateTimeString != null && widget.jobListRepo?.chosenDateTimeString != 'Start Time',
                child: const SizedBox(width: 25,)),
            Visibility(
              visible: widget.jobListRepo?.chosenDateTimeString != null && widget.jobListRepo?.chosenDateTimeString != 'Start Time',
              child: Expanded(
                child: Utils.getDropDownSearch('Select Duration', ['00:15', '00:30', '00:45', '01:00',
                  '01:15', '01:30', '01:45', '02:00', '02:15', '02:30', '02:45', '03:00',
                  '03:15', '03:30', '03:45', '04:00', '04:15', '04:30', '04:45', '03:00'],
                        (value) {
/*
                  if(chosenDateTime != null) {
*/
                          widget.jobListRepo?.selectedHours = value;
                        // debugPrint('selectedHours0: ${int.parse(widget.jobListRepo?.selectedHours!.split(':')[0]!)}');
                        // debugPrint('selectedHours1: ${int.parse(widget.jobListRepo?.selectedHours!.split(':')[1]!)}');
                        Duration duration = Duration(hours:int.parse(widget.jobListRepo!.selectedHours!.split(':')[0]),
                            minutes: int.parse(widget.jobListRepo!.selectedHours!.split(':')[1]));
                        DateTime chosenDateTimeTemp = widget.jobListRepo!.chosenDateTime!;
                          debugPrint('chosenDateTimeTemp: $chosenDateTimeTemp');
                          /*chosenDateTimeTemp!.add(duration);
                        endTimeString = DateFormat('hh:mm a').format(chosenDateTimeTemp!);
                        debugPrint('chosenDateTime: $chosenDateTimeTemp');
                        debugPrint('endTimeString: $endTimeString');
                        setState(() {});*/

                        DateTime startTime = chosenDateTimeTemp;
                        // Duration duration = Duration(hours:2, minutes: 60);
                        DateTime endTime = startTime.add(duration);
                          widget.jobListRepo?.endTimeString = DateFormat('hh:mm a').format(endTime);
                          widget.jobListRepo?.endTimeTFString = DateFormat('HH:MM:ss').format(endTime);
                          debugPrint('widget.jobListRepo?.endTimeTFString: ${widget.jobListRepo?.endTimeTFString}');

                        print(startTime);
                        print(widget.jobListRepo?.endTimeString);
                        print(endTime);
                        setState(() {});
                      /*}else{
                    Utils.showMobileToast('Please select start time');
                  }*/
                    }, widget.jobListRepo?.selectedHours, 'Duration', (context, value, isSelected) {
                      return Utils.popupDropDownBuilder(label: value);
                    }, (context, value) {
                      return Utils.getText(value??'');
                    }),
              ),
            ),
          ],
        ),
const SizedBox(height: 15,),
        Container(
          height: 55,
          // width: 160,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Num.radiusButton),
              border:
              Border.all(color: AppC.fieldBase,
                width: Num.borderWidthField,
              )),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.jobListRepo?.endTimeString??'',
                  style: Utils.getTextStyle(
                      color: AppC.subText,
                      weight: FontWeight.w400,
                      size: 15),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppC.fieldBase,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 200,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: /*DateTime.now(),*/
                  widget.jobListRepo?.chosenDateTimeString != null
                      && widget.jobListRepo?.chosenDateTimeString != 'Start Time' ?
                  widget.jobListRepo?.chosenDateTime! : DateTime.now(),
                  onDateTimeChanged: (val) {
                    debugPrint('chosenDateTimeString: $val');
                    setState(() {
                      widget.jobListRepo!.chosenDateTime = val;
                      debugPrint('chosenDateTime: ${widget.jobListRepo!.chosenDateTime}');
                      widget.jobListRepo?.chosenDateTimeString = DateFormat("hh:mm a").format(val);
                      widget.jobListRepo?.startTimeTFString = DateFormat("HH:MM:ss").format(val);
                      debugPrint('widget.jobListRepo?.startTimeTFString: ${widget.jobListRepo?.startTimeTFString}');

                      if(widget.jobListRepo?.selectedHours != null && widget.jobListRepo?.selectedHours != 'Select Duration'){
                        Duration duration = Duration(
                            hours: int.parse(widget.jobListRepo!.selectedHours!.split(':')[0]),
                            minutes: int.parse(widget.jobListRepo!.selectedHours!.split(':')[1]));
                        DateTime chosenDateTimeTemp = widget.jobListRepo!.chosenDateTime!;
                        /*chosenDateTimeTemp!.add(duration);
                        endTimeString = DateFormat('hh:mm a').format(chosenDateTimeTemp!);
                        debugPrint('chosenDateTime: $chosenDateTimeTemp');
                        debugPrint('endTimeString: $endTimeString');
                        setState(() {});*/

                        DateTime startTime = chosenDateTimeTemp;
                        DateTime endTime = startTime.add(duration);
                        widget.jobListRepo?.endTimeString = DateFormat('hh:mm a').format(endTime);
                        widget.jobListRepo?.endTimeTFString = DateFormat('HH:MM:ss').format(endTime);
                        setState(() {});
                      }
                    });
                  }),
            ),
            // CupertinoButton(
            //   child: const Text('OK'),
            //   onPressed: () {},
            // )
          ],
        ),
      ),
    );
  }
}
