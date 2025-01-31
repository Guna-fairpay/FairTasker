import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleHistoryDetailUI extends StatefulWidget {
  final Map<String, dynamic> outerTodos;
  final Map<String, dynamic> todos;
  final List<Map<String, dynamic>>? categoriesList;
  // final List<UserGroupData>? userGroupList;

  const VehicleHistoryDetailUI(
      {required this.outerTodos,
      required this.todos,
      required this.categoriesList,
      Key? key})
      : super(key: key);

  @override
  State<VehicleHistoryDetailUI> createState() => _VehicleUIState();
}

class _VehicleUIState extends State<VehicleHistoryDetailUI>
    with TickerProviderStateMixin {
  VehicleDataBloc? vehicleDataBloc;
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> tempSearchList = [];
  Color textColors = AppC.text;
  String? expenseId;
  bool showExpenseColumn = false;
  Map<String, dynamic>? expensesData;
  List<Map<String, dynamic>> path = [];
  String? userGroupConcatenationName;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    if (widget.outerTodos['expense_id'] != null &&
        widget.outerTodos['expense_id'] != '' &&
        widget.outerTodos['expense_id'] != '0' &&
        widget.outerTodos['expense_id'] != 'null') {
      expenseId = widget.outerTodos['expense_id'];
    }
    debugPrint(
        'widget.outerTodos!.expenseId: ${widget.outerTodos['expense_id'] ?? 'nj'}');
    debugPrint('widget.todos!.users: ${widget.todos['users'] ?? 'nj'}');
    debugPrint(
        'widget.todos!.userGroupId: ${widget.todos['user_group_id'] ?? ''}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppC.trans,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.black,
                )),
            title: Utils.getText(widget.todos['title'] ?? '',
                size: 18, weight: FontWeight.w700),
            actions: [
              Switch(
                  trackOutlineColor: WidgetStateColor.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppC().base;
                      } else {
                        return AppC.grey;
                      }
                    },
                  ),
                  inactiveThumbColor: AppC.white,
                  inactiveTrackColor: AppC.grey,
                  activeColor: AppC().base,
                  value: widget.todos['status'] == 'Completed',
                  onChanged: (value) {
                    if (widget.todos['status'] == 'Completed') {
                      widget.todos['status'] = 'In Progress';
                    } else {
                      widget.todos['status'] = 'Completed';
                    }
                    //call complete api
                    vehicleDataBloc!.add(CompleteTodoItemVeh(
                        todoId: widget.todos['id'].toString(),
                        status: widget.todos['status']));
                    setState(() {});
                  })
            ],
          ),
          body: BlocProvider(
              create: (context) => vehicleDataBloc!
                ..add(expenseId != null
                    ? GetExpenseToDatas(expenseId: expenseId)
                    : const VehicleInitial()),
              child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
                  listener: (context, state) async {
                if (state is ExpenseTodoDataLoaded) {
                  if (state.expensesData != null) {
                    // expensesData = (state.expensesData??[]);
                    path = expensesData?['attachments'] ?? [];
                    if ((expensesData?['category_id'] ?? 0) != 0) {
                      for (int i = 0;
                          i < (widget.categoriesList ?? []).length;
                          i++) {
                        var element = widget.categoriesList![i];
                        if (element['id'] == expensesData!['category_id']!) {
                          expensesData!['category_name'] = element['name'];
                          for (var element1
                              in (element['subcategories'] ?? [])) {
                            if (element1.userId ==
                                expensesData?['subcategory_id']!) {
                              expensesData?['subCategory_name'] =
                                  element1['name'];
                            }
                          }
                        }
                      }
                    }

                    showExpenseColumn = true;
                  } else {
                    showExpenseColumn = false;
                  }
                }
              }, builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getIconTextRow(
                                Icons.calendar_month_rounded,
                                '${widget.todos['todo_date']!}'
                                '  ${Utils.convertString24HTo12H(widget.todos['todo_time'])}'),
                            Visibility(
                              visible: widget.todos['users'] != null ||
                                  widget.todos['user_group_id'] != null,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(
                                      Icons.perm_identity,
                                      widget.todos['user_group_id'] != null &&
                                              widget.todos['user_group_id'] != 0
                                          ? userGroupConcatenationName!
                                          : '${widget.todos['users']?.firstName?.characters.first.toUpperCase()}'
                                              '${widget.todos['users']?.lastName?.characters.first.toUpperCase()}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            getIconTextRow(
                                Icons.car_repair,
                                widget.outerTodos['vin'] != null
                                    ? widget.outerTodos['vehicle_name']
                                    : widget.outerTodos['vehicle_group_name']),
                            Visibility(
                              visible: (widget.todos['vendor_name'] != null &&
                                      widget.todos['vendor_name'] != 'null') ||
                                  (widget.todos['location'] != null &&
                                      widget.todos['location'] != 'null'),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(
                                      Icons.location_history,
                                      widget.todos['vendor_name'] != null &&
                                              widget.todos['vendor_name'] !=
                                                  'null'
                                          ? '${widget.todos['vendor_name']}'
                                          : widget.todos['location'] != null &&
                                                  widget.todos['location'] !=
                                                      'null'
                                              ? '${widget.todos['location']}'
                                              : ''),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: (widget.todos['notes'] != null &&
                                  widget.todos['notes'] != 'null' &&
                                  widget.todos['notes'] != ''),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(Icons.note_outlined,
                                      widget.todos['notes'] ?? ''),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Visibility(
                                visible:
                                    (widget.todos['parts'] ?? []).isNotEmpty,
                                child: getDetailsInWraps(
                                    (widget.todos['parts'] ?? [])
                                        .map((e) => (e.partsName ?? ''))
                                        .toList(),
                                    '')),
                            Visibility(
                                visible:
                                    (widget.todos['supplies'] ?? []).isNotEmpty,
                                child: getDetailsInWraps(
                                    (widget.todos['supplies'] ?? [])
                                        .map((e) => (e.supplyName ?? ''))
                                        .toList(),
                                    '')),
                            Visibility(
                              visible: showExpenseColumn,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.getText('Expense',
                                      size: 18, weight: FontWeight.bold),
                                  const SizedBox(height: 15),
                                  Visibility(
                                    visible: expensesData?['expense_amount'] !=
                                            null &&
                                        expensesData!['expense_amount'] != 0,
                                    child: Column(
                                      children: [
                                        getIconTextRow(
                                            Icons.monetization_on_outlined,
                                            expensesData?['expense_amount'] !=
                                                        null &&
                                                    expensesData![
                                                            'expense_amount'] !=
                                                        0
                                                ? '${expensesData!['expense_amount']}'
                                                : '0'),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: expensesData?[
                                                'expense_description'] !=
                                            null &&
                                        expensesData!['expense_description'] !=
                                            '',
                                    child: Column(
                                      children: [
                                        getIconTextRow(
                                            Icons.message,
                                            expensesData?['expense_description'] !=
                                                        null &&
                                                    expensesData?[
                                                            'expense_description'] !=
                                                        ''
                                                ? '${expensesData!['expense_description']}'
                                                : ''),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: expensesData?['category_name'] !=
                                            null &&
                                        expensesData?['category_name'] != '',
                                    child: Column(
                                      children: [
                                        getIconTextRow(
                                            Icons.message,
                                            expensesData?['category_name'] !=
                                                        null &&
                                                    expensesData?[
                                                            'category_name'] !=
                                                        ''
                                                ? '${expensesData?['category_name']}'
                                                : ''),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        expensesData?['subCategory_name'] !=
                                                null &&
                                            expensesData?['subCategory_name'] !=
                                                '',
                                    child: Column(
                                      children: [
                                        getIconTextRow(
                                            Icons.message,
                                            expensesData?['subCategory_name'] !=
                                                        null &&
                                                    expensesData?[
                                                            'subCategory_name'] !=
                                                        ''
                                                ? '${expensesData?['subCategory_name']}'
                                                : ''),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: path
                                        .length, // Number of items in the list
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Utils.getText(
                                                path[index]['name'] ?? '',
                                                size: 15),
                                            const SizedBox(height: 8),
                                            CachedNetworkImage(
                                              /*imageBuilder: (context, imageProvider) {
                      return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ));
                    },*/
                                              imageUrl: Str.STORAGE_BASE_URL +
                                                  (path[index]['path'] ?? Str.errorImage),
                                              placeholder: (context, url) =>
                                                  Utils.getProgressIndicator(
                                                      context),
                                              errorWidget:
                                                  (context, url, error) {
                                                return Container(
                                                    height: 100,
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 0),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    alignment: Alignment.center,
                                                    child: Utils.getText("CT",
                                                        size: 22,
                                                        color: AppC.red,
                                                        weight:
                                                            FontWeight.bold));
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state is VehicleDataLoading,
                        child:
                            Center(child: Utils.getProgressIndicator(context)))
                  ],
                );
              }))),
    );
  }

  Widget getIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppC.text,
          size: 22,
        ),
        const SizedBox(
          width: 8,
        ),
        Utils.getText(text)
      ],
    );
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
      child: Wrap(
        children: List<Widget>.generate(
          list.length,
          (int idx) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Chip(
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  backgroundColor: AppC().bottomIconColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  label: Utils.getText(list[idx] ?? '',
                      color: AppC.text, size: 14),
                ));
          },
        ).toList(),
      ),
    );
  }
}
