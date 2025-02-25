
import 'dart:developer';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:flutter/material.dart';
import '../../Event/todo_view_event.dart';
import '../../Response/create_fix_task_data.dart';
import '../../Utilities/Str.dart';
import '../../Utilities/Utils.dart';
import '../../Utilities/appC.dart';

class CheckListUI extends StatefulWidget {
  final List<Map<String, dynamic>> checkListData;
  final Map<String, dynamic> todoItems;
  late final Map<String, dynamic> vehicle;

  CheckListUI({super.key, required this.checkListData,required this.todoItems, required this.vehicle,})
  {
    print("vehicle data ${vehicle}");
    print("vehicle data ${todoItems}");
    print("vehicle data is${checkListData}");
  }

  @override
  State<CheckListUI> createState() => _CheckListUIState();
}

class _CheckListUIState extends State<CheckListUI> {
  TodoViewBloc? todoViewBloc;
  TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  String? userId;
  bool isLoading = false;
  Map<int, bool> checkBoxStates = {};
  Map<String, dynamic> todoItems = {};
  String? notes;
  String? title;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    data = widget.checkListData;
    todoViewBloc = TodoViewBloc();
    todoItems=widget.todoItems;
    for (var item in data) {
      checkBoxStates[item['id']] = true;
    }
  }


  @override
  void didUpdateWidget(covariant CheckListUI oldWidget){
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checkListData != widget.checkListData) {
      data = widget.checkListData;
      todoViewBloc = TodoViewBloc();
      for (var item in data) {
        checkBoxStates[item['id']] = true;
      }
      setState(() {});
    }
  }

  Future<void> _loadUserId() async {
    final id = await Utils.getStringPreference(Str.userIdPrefText);
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return checkList(data[index], index);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
            if (todoItems['title'] == 'Getaround Prechecks')
              Utils.getText('Immobilizer Check')
          ],
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Utils.getProgressIndicator(context),
              ),
            ),
          ),
      ],
    );
  }

  Widget checkList(Map<String, dynamic> checkListData, int index) {
    int itemId = checkListData['id'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: AppC.blue,
              value: checkBoxStates[itemId] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  checkBoxStates[itemId] = value ?? false;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(checkListData['title']?.toString() ?? ''),
                Utils.getText("(${checkListData['description']?.toString() ?? ''})"),
              ],
            ),
          ],
        ),
        if (!(checkBoxStates[itemId] ?? false))
          Padding(
            padding: const EdgeInsets.only(left: 50.0,right: 20),
            child:
            Column(spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.getBorderedMultilineTextField('Notes', notesController,minLines: 2),
              Utils.getAddFilledButton('Create Task',
                      () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(Duration.zero);
                    try {
                      notes = '${checkListData['title']}-${notesController.text}';

                      title = switch (checkListData['id']) {
                        1 => 'Clean Car',
                        7 => 'Oil Change Check',
                        8 => 'Refuel Car',
                        _ => 'Fix',
                      };
                      CreateFixTaskData createFixTaskData = CreateFixTaskData();
                      createFixTaskData.userId=widget.todoItems['user_id'];
                      createFixTaskData.userGroupId=widget.todoItems['user_group_id'];
                      createFixTaskData.title=title;
                      createFixTaskData.notes=notes;
                      createFixTaskData.todoTime=widget.todoItems['todo_time'];
                      createFixTaskData.startAt=widget.todoItems['todo_date'];
                      createFixTaskData.vehicleList=widget.todoItems['vehicles'];
                      createFixTaskData.location=widget.todoItems['location'];
                      createFixTaskData.locationId=widget.todoItems['location_id'];
                      createFixTaskData.vendorId=widget.todoItems['vendor_id'];
                      createFixTaskData.vendorName=widget.todoItems['vendor_name'];
                      createFixTaskData.vehicleNumber=widget.vehicle['vehicle_number'];
                      todoViewBloc!.add(AddFixTask(
                        createFixTaskData: createFixTaskData,
                      ));
                      await Future.delayed(const Duration(seconds: 2));
                      Utils.showMobileToast('$title Task Created');
                    } catch (e) {
                      Utils.showMobileToast('ERROR : $e');
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  bgColor: AppC.green)
            ],
          ),
          ),
        Visibility(
            visible: isLoading,
            child: Center(child: Utils.getProgressIndicator(context)))
      ],
    );
  }
}
