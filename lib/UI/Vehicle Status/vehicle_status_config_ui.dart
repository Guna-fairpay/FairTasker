import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusConfigUI extends StatefulWidget {
  final String? vehicleName;
  final String? vinNumber;
  final Map<String, dynamic>? vehicleStatusListData;
  const VehicleStatusConfigUI(
      {required this.vehicleName,
      required this.vinNumber,
      required this.vehicleStatusListData,
      Key? key})
      : super(key: key);

  @override
  State<VehicleStatusConfigUI> createState() => _VehicleStatusConfigUIState();
}

class _VehicleStatusConfigUIState extends State<VehicleStatusConfigUI> {
  late TodoViewBloc todoViewBloc;
  bool showSearchRow = false;
  List<Map<String, dynamic>>? vehicleConfigData;
  List<Map<String, dynamic>> vehicleConfigCategoriesList = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
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
            title: Utils.getText('${widget.vehicleName} - ${widget.vinNumber}',
                size: 18, weight: FontWeight.w700)),
        body: BlocProvider(
            create: (context) => todoViewBloc
              ..add(GetVehicleStatusConfigList(vinNumber: widget.vinNumber)),
            child: BlocConsumer<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
              if (state is GetVehicleStatusConfigListLoaded) {
                if (state.vehicleStatusConfigResponse != null) {
                  vehicleConfigData =
                      state.vehicleStatusConfigResponse!.vehicle;
                  vehicleConfigCategoriesList.clear();
                  // for (var element in (state.vehicleStatusConfigResponse!.categories??[])) {
                  //   if(element.checked==1) {
                  //     vehicleConfigCategoriesList.add(element);
                  //   }
                  // }
                  vehicleConfigCategoriesList =
                      state.vehicleStatusConfigResponse!.categories ?? [];
                }
              } else if (state is ReorderVehicleStatusCheckListLoaded) {
                if (state.result != null) {
                  Navigator.of(context).pop();
                }
              } else if (state is SelectedVehicleCategoriesLoaded) {
                todoViewBloc.add(
                    GetVehicleStatusConfigList(vinNumber: widget.vinNumber));
              } else if (state is GetVehicleStatusCheckListLoaded) {
                if (state.data != null && state.categories != null) {
                  categories = state.categories ?? [];
                  for (var element in categories) {
                    if (element['id'] == state.categoryId) {
                      getCheckListOrderDialog(
                          context,
                          element['categoryName'] ?? '',
                          state.checkListId ?? 0,
                          (element['checklists'] ?? []));
                      return;
                    }
                  }
                }
              }
            }, builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          trailing: const Icon(Icons.arrow_drop_down_rounded,
                              color: AppC.subText),
                          title: Utils.getText('Vehicle Status Config',
                              size: 16, weight: FontWeight.bold),
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              childAspectRatio: 5.5,
                              physics: const NeverScrollableScrollPhysics(),
                              children: vehicleConfigCategoriesList
                                  .map(
                                    (item) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          activeColor: AppC().base,
                                          value: item['checked'] == 1,
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                item['checked'] = value ? 1 : 0;
                                              });
                                              todoViewBloc.add(
                                                  VehicleStatusConfigSelectedCategories(
                                                      categoryId: item['id'],
                                                      vinNumber:
                                                          widget.vinNumber,
                                                      categoryIds: [
                                                        item['id']!
                                                      ],
                                                      checkboxValue:
                                                          value ? 1 : 0,
                                                      isApi: 1));
                                            }
                                          },
                                        ),
                                        Utils.getText(
                                            item['category_name'] ?? ''),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => Visibility(
                              visible:
                                  true /*vehicleConfigCategoriesList?.elementAt(index).checked == 1*/,
                              child: ExpansionTile(
                                trailing: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: AppC.subText),
                                title: Utils.getText(
                                    vehicleConfigCategoriesList.elementAt(
                                            index)['category_name'] ??
                                        '',
                                    size: 16,
                                    weight: FontWeight.bold),
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            activeColor: AppC().base,
                                            value: getAllItemsChecked(
                                                vehicleConfigCategoriesList
                                                    .elementAt(
                                                        index)['checklists']!),
                                            onChanged: (value) {
                                              if (value != null) {
                                                vehicleConfigCategoriesList
                                                    .elementAt(
                                                        index)['checklists']
                                                    ?.forEach((element) =>
                                                        element.checked =
                                                            value ? 1 : 0);
                                                setState(() {});
                                                String catIds =
                                                    vehicleConfigCategoriesList
                                                        .elementAt(index)[
                                                            'checklists']!
                                                        .map((checklist) =>
                                                            checklist
                                                                .categoryId)
                                                        .join(', ');
                                                todoViewBloc.add(
                                                    VehicleStatusCheckListCheck(
                                                        vinNumber:
                                                            widget.vinNumber,
                                                        categoryId:
                                                            vehicleConfigCategoriesList
                                                                .elementAt(index)['id'],
                                                        checked: value,
                                                        type: 'all',
                                                        categoryIds: [catIds]));
                                              }
                                            },
                                          ),
                                          Utils.getText('Check All'),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                todoViewBloc.add(
                                                    GetVehicleStatusCheckList(
                                                        vinNumber:
                                                            widget.vinNumber,
                                                        categoryId:
                                                            vehicleConfigCategoriesList
                                                                    .elementAt(
                                                                        index)[
                                                                'id'],
                                                        categoryName: null));
                                              },
                                              child: Icon(
                                                Icons.settings_brightness_sharp,
                                                color: AppC().base,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    childAspectRatio: 5.5,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: List<Widget>.from(
                                      vehicleConfigCategoriesList
                                          .elementAt(index)['checklists']!
                                          .map(
                                            (item) => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Checkbox(
                                                  activeColor: AppC().base,
                                                  value: item['checked'] == 1,
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        item['checked'] =
                                                            value ? 1 : 0;
                                                      });
                                                      todoViewBloc.add(
                                                        VehicleStatusCheckListCheck(
                                                          vinNumber:
                                                              widget.vinNumber,
                                                          categoryId: item[
                                                              'categoryId'],
                                                          checkItemId:
                                                              item['id'],
                                                          checked: value,
                                                          categoryIds: [
                                                            (item['categoryId'] ??
                                                                    0)
                                                                .toString()
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                Utils.getText(
                                                    item['label'] ?? ''),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            itemCount: vehicleConfigCategoriesList.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: state is TodoListLoading,
                    child: Center(child: Utils.getProgressIndicator(context)),
                  ),
                ],
              );
            })));
  }

  bool getAllItemsChecked(List<dynamic> list) {
    return !list.any((element) => element['checked'] != 1);
  }

  void getCheckListOrderDialog(BuildContext context, String title,
      int categoryId, List<Map<String, dynamic>> list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Utils.getText(title, size: 18, weight: FontWeight.w500),
        content: SizedBox(
            height: MediaQuery.of(context).size.height /*/1.2*/,
            width: MediaQuery.of(context).size.width /*/1.2*/,
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                // debugPrint('from,to: ${todoList![oldIndex].id.toString()}, ${todoList![newIndex].id.toString()}');
                // List<int> orderList = [];
                // orderList.addAll(list.map((element) =>element.checklistId!).toList());
                swapValues(list, oldIndex, newIndex);
                todoViewBloc.add(ReorderVehicleStatusCheckList(
                    vinNumber: widget.vinNumber,
                    categoryId: categoryId,
                    orderCheckList: swapValues(list, oldIndex, newIndex)));
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey(index),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: Utils.getBoxDecoration(bgColor: AppC.lightGrey),
                  child: Utils.getText(
                      '${list[index]['checklist_name'] ?? ''} - ${list[index]['order_no'] ?? 0}'),
                );
              },
            )),
        actions: [
          Utils.getOutlinedButton('Close', () {
            Navigator.of(context).pop();
          }, verticalPadding: 5, borderColor: AppC().base),
        ],
      ),
    );
  }

  List<dynamic> swapValues(
      List<Map<String, dynamic>> list, int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= list.length ||
        newIndex < 0 ||
        newIndex >= list.length) {
      // Indices out of range, cannot perform swap
      return [];
    }

    Map<String, dynamic> temp = list[oldIndex];
    list[oldIndex] = list[newIndex];
    list[newIndex] = temp;

    return list.map((e) => e['checklist_Id']!).toList();
  }

  void doSetState() {
    setState(() {});
  }
}
