import 'dart:async';
import 'dart:convert';

import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history_detail_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class VehicleHistoryModuleUI extends StatefulWidget {
  // final List<Todos>? vehicleHistoryTempSearchList;
  final TodoListRepo? todoListRepo;
  final FocusNode searchFocusNode = FocusNode();

  final Map<String, dynamic> outerTodos;
  final List<Map<String, dynamic>>? userGroupList;
  final List<Map<String, dynamic>>? resourceList;

  VehicleHistoryModuleUI(
      {required this.outerTodos,
      required this.userGroupList,
      required this.resourceList,
      required this.todoListRepo,
      Key? key})
      : super(key: key);

  @override
  State<VehicleHistoryModuleUI> createState() => _VehicleHistoryModuleUIState();
}

class _VehicleHistoryModuleUIState extends State<VehicleHistoryModuleUI>
    with TickerProviderStateMixin {
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> todoList = [];
  // List<Todos> tempSearchList = [];
  Color textColors = AppC.text;
  String lastEditedId = '';
  OverlayEntry? overlay;
  String? userGroupConcatenationName;
  DateTime? todoDateTime;
  bool? isVehicleEdit = false;
  bool? isPartsEdit = false;
  bool? isSupplyEdit = false;
  bool? isMultipleVehicleEdit = false;
  bool? isMultipleAddressEdit = false;
  bool? isVendorEdit = false;
  bool? isVehicleGroupEdit = false;
  bool? isNotesEdit = false;
  String? vehicleGroupName;

  void show(BuildContext context, String message, String status) {
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0,
        left: MediaQuery.of(context).size.width * 0.1,
        child: ToastWidget(message, () {
          if (overlay != null) {
            overlay?.remove();
          }
          vehicleDataBloc
              .add(CompleteTodoItemVeh(todoId: lastEditedId, status: status));
        }),
      ),
    );
    Overlay.of(context).insert(overlay!);
    Timer(const Duration(seconds: 3), () {
      if (overlay != null) {
        overlay?.remove();
      }
    });
  }
/*  // Expose a method to trigger both the refresh and the event
  void triggerRefreshAndEvent() {
    onRefresh?.call();
    // Assuming vehicleDataBloc is accessible here, you may need to adjust based on your code structure
    vehicleDataBloc!.add(
            GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId));
  }
  void onRefresh() {
    debugPrint('vehicleHistoryModule: refreshTheList');
    widget.onRefresh!.call();
    vehicleDataBloc!.add(
    GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId));
  }*/

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    todoDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return vehicleHistoryUIWithoutScaffold();
  }

  Widget vehicleHistoryUIWithoutScaffold() {
    return BlocProvider(
        create: (context) => vehicleDataBloc
          ..add(GetVehicleHistoryEvent(
              vin: widget.outerTodos['vin'],
              vehicleGroupId: widget.outerTodos['vehicle_group_id'])),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is TodoItemCompletedVeh) {
            show(
                context,
                (state.status) == 'In Progress'
                    ? 'The todo marked as In Progress.'
                    : 'The todo marked as Completed.',
                (state.status) == 'In Progress' ? 'Completed' : 'In Progress');
            if (state.result != null && state.result!) {
              vehicleDataBloc.add(GetVehicleHistoryEvent(
                  vin: widget.outerTodos['vin'],
                  vehicleGroupId: widget.outerTodos['vehicle_group_id']));
            }
          } else if (state is VehicleHistoryLoaded) {
            if (state.vehicleHistoryList != null) {
              todoList.clear();
              widget.todoListRepo!.vehicleHistoryTempSearchList.clear();
              for (Map<String, dynamic> todos in state.vehicleHistoryList!) {
                if (todos['status'] == 'Completed') {
                  textColors = AppC().base;
                } else {
                  textColors = AppC.text;
                }
              }
              List<Map<String, dynamic>> list = [];
              list.addAll(state.vehicleHistoryList ?? []);
              // list.sort((a, b) => DateTime.parse(a.createdAt??'').compareTo(DateTime.parse(b.createdAt??'')));

              // Combine date and time strings into DateTime objects
              // List<Todos> dateTimeList = [];
              for (int i = 0; i < list.length; i++) {
                String dateString = list[i]['todo_date']!;
                String timeString = list[i]['todo_time']!;
                DateTime dateTime = DateTime.parse('$dateString $timeString');
                todoDateTime = dateTime;
              }

              // Sort the DateTime list in descending order
              //list.sort((a, b) => b.todoDateTime!.compareTo(a.todoDateTime!));

              // Print the sorted list
              /*for (var dateTime in dateTimeList) {
                    print(dateTime);
                  }*/

              todoList.addAll(list /*.reversed.toList()*/);

              widget.todoListRepo!.vehicleHistoryTempSearchList
                  .addAll(todoList /*state.vehicleHistoryList!*/);
              debugPrint(
                  'cleancar.title: ${(widget.todoListRepo!.vehicleHistoryTempSearchList)[0]['title'] ?? ''}');
            }
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              RefreshIndicator(
                color: AppC().base,
                onRefresh: () async {
                  vehicleDataBloc.add(GetVehicleHistoryEvent(
                      vin: widget.outerTodos['vin'],
                      vehicleGroupId: widget.outerTodos['vehicle_group_id']));
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.todoListRepo!
                              .vehicleHistoryTempSearchList.isNotEmpty,
                          child: Utils.getSearchBarUI(() {
                            //onTap
                          }, (value) {
                            //    onChange
                            todoList.clear();
                            if (value.isEmpty) {
                              todoList.addAll(widget
                                  .todoListRepo!.vehicleHistoryTempSearchList);
                            } else {
                              for (Map<String, dynamic> data in widget
                                  .todoListRepo!.vehicleHistoryTempSearchList) {
                                if (((data['title'] ?? '').toLowerCase())
                                    .contains(value.toLowerCase())) {
                                  todoList.add(data);
                                }
                              }
                            }
                            setState(() {});
                          }, searchController, searchFocusNode),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: todoList.isNotEmpty,
                          replacement: Center(
                              child: Utils.getEmptyTextWidget(topPadding: 30)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: todoList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () async {
                                      bool? result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleHistoryDetailUI(
                                          outerTodos: widget.outerTodos,
                                          todos: todoList[index],
                                          categoriesList: const [],
                                        ),
                                      ));
                                      if (result != null) {
                                        vehicleDataBloc.add(
                                            GetVehicleHistoryEvent(
                                                vin: widget.outerTodos['vin'],
                                                vehicleGroupId:
                                                    widget.outerTodos[
                                                        'vehicle_group_id']));
                                      }
                                    },
                                    child: listItem(todoList[index], index));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: state is VehicleDataLoading,
                  child: Center(child: Utils.getProgressIndicator(context)))
            ],
          );
        }));
  }

  // Function to parse datetime string into DateTime object
  DateTime _parseDateTime(String datetimeString) {
    return DateTime.parse(datetimeString).toLocal();
  }

  // Function to compare times
  int _compareTime(DateTime time1, DateTime time2) {
    if (time1.hour != time2.hour) {
      return time1.hour.compareTo(time2.hour);
    } else if (time1.minute != time2.minute) {
      return time1.minute.compareTo(time2.minute);
    } else if (time1.second != time2.second) {
      return time1.second.compareTo(time2.second);
    } else {
      return 0; // Times are equal
    }
  }

  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  Widget listItem(Map<String, dynamic> todos, int index) {
    return Row(
      children: [
        Utils.getText(todos['todo_date'] ?? '',
            weight: FontWeight.bold, color: textColors),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Slidable(
            key: ValueKey(index),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    lastEditedId = todos['id'].toString();
                    vehicleDataBloc.add(CompleteTodoItemVeh(
                        todoId: lastEditedId,
                        status: (todos['status'] == 'In Progress')
                            ? 'Completed'
                            : 'In Progress'));
                  },
                  foregroundColor: todos['status'] == 'In Progress'
                      ? AppC.green
                      : AppC.black,
                  label: todos['status'] == 'In Progress'
                      ? 'Complete'
                      : 'In Progress',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom:
                      BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0,
                        5), // Adjust the offset for the side you want the shadow
                  ),
                ],
                color: AppC.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Utils.getText('${todos['title']}',
                            weight: FontWeight.bold, color: textColors),
                      ),
                      Utils.getText(
                          Utils.convertString24HTo12H(todos['todo_time']),
                          color: textColors)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Visibility(
                          visible: (todos['vehicle_name'] != null &&
                                  todos['vehicle_name'] != 'null') ||
                              (todos['person'] != null &&
                                  todos['person'] != 'null') ||
                              (isPartsEdit != null && isPartsEdit!) ||
                              (isSupplyEdit != null && isSupplyEdit!) ||
                              (todos['vehicle_group_id'] != null &&
                                  todos['vehicle_group_id'] != 0),
                          child: InkWell(
                              onTap: () {},
                              child: isPartsEdit!
                                  ? getDetailsInWraps(
                                      (todos['parts'] ?? [])
                                          .map((e) => (e.partsName ?? ''))
                                          .toList(),
                                      '')
                                  : isSupplyEdit!
                                      ? getDetailsInWraps(
                                          (todos['supplies'] ?? [])
                                              .map((e) => (e.supplyName ?? ''))
                                              .toList(),
                                          '')
                                      : isVehicleGroupEdit!
                                          ? getDetailsInWraps(
                                              (todos['vehicleGroupList'] ?? [])
                                                  .map((e) =>
                                                      (e.vehicleName ?? ''))
                                                  .toList(),
                                              vehicleGroupName ?? '')
                                          : Utils.getText('')
                              // : Utils.getText(''),
                              ),
                        ),
                      ),
                      Visibility(
                        visible: isPartsEdit! ||
                            isSupplyEdit! ||
                            isVehicleGroupEdit!,
                        child: InkWell(
                          onTap: () {
                            isPartsEdit = false;
                            isSupplyEdit = false;
                            isVehicleGroupEdit = false;
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                border: Border.all(
                                    color: AppC.fieldBase /*, width: 0.2*/)),
                            child: const Icon(
                              Icons.clear_rounded,
                              color: AppC.red,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      // TODO: show parts and supply
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (todos['parts'] ?? []).isNotEmpty,
                        child: InkWell(
                            onTap: () {
                              isPartsEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('P',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors)),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (todos['supplies'] ?? []).isNotEmpty,
                        child: InkWell(
                            onTap: () {
                              isSupplyEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('S',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors)),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (todos['vehicle_group_id'] != null &&
                            todos['vehicle_group_id'] != 0),
                        child: InkWell(
                            onTap: () {
                              isVehicleGroupEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('G',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Utils.getText(
                                  todos['vendor_name'] != null &&
                                          todos['vendor_name'] != 'null'
                                      ? '${todos['vendor_name']}'
                                      : todos['location'] != null &&
                                              todos['location'] != 'null'
                                          ? '${todos['location']}'
                                          : '',
                                  color: textColors),
                            ),
                            Visibility(
                              visible: todos['notes'] != null &&
                                  todos['notes'] != 'null',
                              child: Expanded(
                                child: Utils.getText(
                                    todos['notes'] != null &&
                                            todos['notes'] != 'null'
                                        ? ' (${todos['notes'] ?? ''}) '
                                        : '',
                                    overFlow: TextOverflow.ellipsis,
                                    color: textColors),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: todos['users'] != null ||
                            todos['user_group_id'] != null,
                        child: todos['users'] != null
                            ? Utils.getText(
                                '${todos['users']?.firstName?.characters.first.toUpperCase()}'
                                '${todos['users']?.lastName?.characters.first.toUpperCase()}',
                                weight: FontWeight.bold,
                                color: textColors)
                            : getUserGroupDataById(todos),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserGroupDataById(Map<String, dynamic> todos) {
    userGroupConcatenationName = '';
    for (Map<String, dynamic> u in (widget.userGroupList ?? [])) {
      if (u['id'] == todos['user_group_id']) {
        List<dynamic> jsonList = json.decode(u['userId'] ?? '');
        List<dynamic> resultList = jsonList.cast<dynamic>();
        for (dynamic userId in resultList) {
          for (Map<String, dynamic> res in (widget.resourceList ?? [])) {
            if (userId.toString() == res['id'].toString()) {
              userGroupConcatenationName =
                  '${userGroupConcatenationName ?? ''}${res['first_name']?.characters.first.toUpperCase()}${res['first_name']?.characters.first.toUpperCase()}, ';
            }
          }
        }
      }
    }
    return Utils.getText(userGroupConcatenationName ?? '',
        color: textColors, weight: FontWeight.bold);
  }

  Widget getDetailsInWraps(List<String> list, String title) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthField,
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(Num.radiusButton))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.getText(title),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            children: List<Widget>.generate(
              list.length,
              (int idx) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 2),
                    child: Chip(
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      backgroundColor: AppC().bottomIconColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      label: Utils.getText(list[idx],
                          color: AppC.text, size: 13),
                    ));
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class ToastWidget extends StatelessWidget {
  final String message;
  final VoidCallback undoCallback;

  const ToastWidget(this.message, this.undoCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppC.trans,
      child: Card(
        elevation: 8,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: AppC.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(Num.radiusButton),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Utils.getText(
                message,
                size: 16,
                color: AppC.text,
              ),
              Utils.getFilledButton('Undo', undoCallback, verticalPadding: 2)
            ],
          ),
        ),
      ),
    );
  }
}
