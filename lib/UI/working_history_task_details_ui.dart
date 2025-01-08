import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkingHistoryTaskDetailUI extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final int? id;

  const WorkingHistoryTaskDetailUI(
      {required this.title, required this.subTitle, required this.id, Key? key})
      : super(key: key);

  @override
  State<WorkingHistoryTaskDetailUI> createState() =>
      _WorkingHistoryTaskDetailUIState();
}

class _WorkingHistoryTaskDetailUIState extends State<WorkingHistoryTaskDetailUI>
    with TickerProviderStateMixin {
  TodoViewBloc? todoBloc;
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> tempSearchList = [];
  Color textColors = AppC.text;
  List<Map<String, dynamic>> path = [];
  Map<String, dynamic>? todoData;

  @override
  void initState() {
    super.initState();
    todoBloc = TodoViewBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            todoBloc!..add(GetTaskDetailData(id: (widget.id ?? 0))),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
            listener: (context, state) async {
          if (state is GetTaskDetailDataLoaded) {
            todoData = state.todo! as Map<String, dynamic>;
            /*
                    path = (state.expenseSummaryData?.attachments ?? []);
                    if ((state.expenseSummaryData?.categoryId ?? 0) != 0) {

                      for (int i=0; i<(widget.categoriesList ?? []).length; i++) {
                        var element = widget.categoriesList![i];
                        if (element.id == expenseSummaryData!.categoryId!) {
                          expenseSummaryData!.categoryName = element.name;
                          for (var element1 in (element.subCategories ?? [])) {
                            if (element1.id == expenseSummaryData!.subcategoryId!) {
                              expenseSummaryData!.subCategoryName = element1.name;
                            }
                          }
                        }
                      }
                    }
    */
          }
        }, builder: (context, state) {
          return Scaffold(
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
              title: Utils.getText(((todoData?['title'] ?? '')),
                  size: 18, weight: FontWeight.w700),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (todoData?['todo_date'] != null &&
                              todoData!['todo_date']!.isNotEmpty),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              getIconTextRow(Icons.calendar_month,
                                  '${todoData?['todo_date'] ?? ''} - ${todoData?['todo_time'] ?? ''}'),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: todoData?['vehicle_name'] != null &&
                              todoData!['vehicle_name']!.isNotEmpty,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              getIconTextRow(Icons.car_repair_rounded,
                                  todoData?['vehicle_name'] ?? ''),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (todoData?['vendor_name'] != null &&
                              todoData!['vendor_name']!.isNotEmpty),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              getIconTextRow(Icons.perm_identity,
                                  todoData?['vendor_name'] ?? ''),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (todoData?['notes'] != null &&
                              todoData!['notes']!.isNotEmpty),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              getIconTextRow(Icons.description_outlined,
                                  todoData?['notes'] ?? ''),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: state is TodoListLoading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            ),
          );
        }));
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
