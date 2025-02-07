import 'package:fairpytasker/UI/Expense/expense_summary_details_ui.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSummaryUI extends StatefulWidget {
  final String? vinNumber;
  final String? vehicleName;
  final Color? appBarColor;
  final List<Map<String, dynamic>>? categoriesList;
  final Map<String, dynamic> todos;
  const ExpenseSummaryUI(
      {Key? key,
      this.appBarColor,
      this.vehicleName,
      this.vinNumber,
      this.categoriesList,
      required this.todos})
      : super(key: key);

  @override
  State<ExpenseSummaryUI> createState() => _ExpenseSummaryUIState();
}

class _ExpenseSummaryUIState extends State<ExpenseSummaryUI> {
  TodoViewBloc? todoBloc;
  // Color appBarColor = AppC.lowP;
  String appBarTitle = 'Expense Summary';
  Map<String, dynamic>? expenseSummaryList;

  @override
  void initState() {
    todoBloc = TodoViewBloc();
    appBarTitle = '${widget.vehicleName ?? ''} - ${widget.vinNumber ?? ''}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            titleTextStyle: const TextStyle(color: AppC.white),
            elevation: 0,
            backgroundColor: widget.appBarColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.white,
                )),
            title: Utils.getText(appBarTitle,
                size: 18, color: AppC.white, weight: FontWeight.w700)),
        body: BlocProvider(
            create: (context) => todoBloc!
              ..add(GetExpenseSummaryData(vinNumber: widget.vinNumber)),
            child: BlocConsumer<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
              if (state is ExpenseSummaryLoaded) {
                if (state.expenseSummaryList != null) {
                  expenseSummaryList = state.expenseSummaryList??{};
                }
              }
            }, builder: (context, state) {
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      todoBloc!.add(
                          GetExpenseSummaryData(vinNumber: widget.vinNumber));
                    },
                    child: SingleChildScrollView(
                      child: Visibility(
                        // visible: todoList != null && todoList!.isNotEmpty,
                        // replacement: Utils.getEmptyTextWidget(topPadding: 30),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: expenseSummaryList?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: const BorderSide(
                                      color: AppC.white, width: 1),
                                  left: const BorderSide(
                                      color: AppC.white, width: 1),
                                  right: const BorderSide(
                                      color: AppC.white, width: 1),
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.1),
                                      width: 1),
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
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Utils.getText(
                                          (expenseSummaryList?[index]
                                                  ['expense_date'] ??
                                              ''))),
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Utils.getText(
                                            (expenseSummaryList?[index]
                                                        ['expense_amount'] ??
                                                    0)
                                                .toString()),
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: Utils.getText(
                                        expenseSummaryList?[index]
                                                ['expense_description'] ??
                                            ''),
                                  ),
                                  Visibility(
                                    visible: (expenseSummaryList?[index]
                                                ['attachments'] ??
                                            [])
                                        .isNotEmpty,
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint(
                                            'attachments!.length: ${expenseSummaryList?[index]['attachments']!.length}');
                                        List<String> path =
                                            (expenseSummaryList?[index]
                                                    ['attachments']!
                                                .map((e) => e.path ?? '')
                                                .toList());
                                        debugPrint(
                                            'attachments.jsonEncode: $path');
                                        // Utils.getImageTitleDialog(context, widget.vehicleName??'', path);
                                        // Utils.getVerticalListOfImageTitleDialog(context, widget.vehicleName??'', path);
                                        Utils.getVerticalListOfImageTitleDialog(
                                            context,
                                            widget.vehicleName ?? '',
                                            path);
                                      },
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: AppC().base,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      // expenseSummaryList[index].categoryName = widget.todos.ca
                                      // expenseSummaryList[index].subCategoryName =
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ExpenseSummaryDetailUI(
                                                expenseId:
                                                    expenseSummaryList?[index]
                                                            ['id']!
                                                        .toString(),
                                                categoriesList:
                                                    widget.categoriesList,
                                                todoId: widget.todos['id']),
                                      ));
                                    },
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: AppC().base,
                                      size: 18,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: state is TodoListLoading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            })));
  }
}
