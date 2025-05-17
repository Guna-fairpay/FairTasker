import 'package:fairpytasker/UI/Expense/edit_expense_ui.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExpenseSummaryDetailUI extends StatefulWidget {
  // final ExpenseSummaryData? expenseSummaryData;
  final int? todoId;
  final String? expenseId;
  final List<Map<String, dynamic>>? categoriesList;

  const ExpenseSummaryDetailUI(
      {required this.expenseId,
      required this.categoriesList,
      required this.todoId,
      Key? key})
      : super(key: key);

  @override
  State<ExpenseSummaryDetailUI> createState() => _ExpenseSummaryDetailUIState();
}

class _ExpenseSummaryDetailUIState extends State<ExpenseSummaryDetailUI>
    with TickerProviderStateMixin {
  TodoViewBloc? todoBloc;
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> tempSearchList = [];
  Color textColors = AppC.text;
  Map<String, dynamic>? path;
  Map<String, dynamic>? expenseSummaryData;

  @override
  void initState() {
    super.initState();
    todoBloc = TodoViewBloc();
/*    if(widget.expenseSummaryData != null) {
      expenseSummaryData = widget.expenseSummaryData;

      for (int i=0; i<(widget.categoriesList ?? []).length; i++) {
        var element = widget.categoriesList![i];
        if (element.id == widget.expenseSummaryData!.categoryId!) {
          widget.expenseSummaryData!.categoryName = element.name;
          for (var element1 in (element.subCategories ?? [])) {
            if (element1.id == widget.expenseSummaryData!.subcategoryId!) {
              widget.expenseSummaryData!.subCategoryName = element1.name;
             }
          }
         }
      }
      if(widget.expenseSummaryData?.attachments!=null) {
        path = (widget.expenseSummaryData!.attachments!*/ /*
            .map((e) => e.path ?? '')
            .toList()*/ /*);
      }
    }*/
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
            title: Utils.getText('View Expense',
                size: 18, weight: FontWeight.w700),
          ),
          body: BlocProvider(
              create: (context) =>
                  todoBloc!..add(GetExpenseToData(expenseId: widget.expenseId)),
              child: BlocConsumer<TodoViewBloc, TodoViewState>(
                  listener: (context, state) async {
                if (state is ExpenseTodoLoaded) {
                  expenseSummaryData =
                      (state.expenseSummaryData ?? []) as Map<String, dynamic>?;
                  /*expenseDescriptionController.text =
                          state.expenseSummaryData?.expenseDescription ?? '';
                      amountController.text =
                          (state.expenseSummaryData?.expenseAmount ?? 0)
                              .toString();*/
                  path = (expenseSummaryData?['attachments'] ?? []);
                  if ((expenseSummaryData?['category_id'] ?? 0) != 0) {
                    for (int i = 0;
                        i < (widget.categoriesList ?? []).length;
                        i++) {
                      var element = widget.categoriesList![i];
                      if (element['id'] == expenseSummaryData!['category_id']) {
                        expenseSummaryData!['category_name'] = element['name'];
                        for (var element1 in (element['subcategories'] ?? [])) {
                          if (element1['id'] ==
                              expenseSummaryData!['subcategory_id']!) {
                            expenseSummaryData!['subCategory_name'] =
                                element1['name'];
                          }
                        }
                      }
                    }
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
                            Row(
                              children: [
                                Expanded(
                                    child: getIconTextRow(
                                        Icons.monetization_on_outlined,
                                        '${expenseSummaryData?['expense_amount'] ?? 0}')),
                                Visibility(
                                  visible: (getIt<CommonService>().userPermissions ?? [])
                                      .contains(Str.editExpensePermission),
                                  child: InkWell(
                                    onTap: () async {
                                      bool? refresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditExpenseUI(
                                              expenseSummaryData:
                                                  expenseSummaryData,
                                              categoriesListData:
                                                  widget.categoriesList,
                                              todoId: widget.todoId),
                                        ),
                                      );
                                      if (refresh != null && refresh) {
                                        todoBloc!.add(GetExpenseToData(
                                            expenseId: widget.expenseId));
                                      }
                                    },
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: AppC.text,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: expenseSummaryData?[
                                          'expense_description'] !=
                                      null &&
                                  expenseSummaryData!['expense_description']!
                                      .isNotEmpty,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(
                                      Icons.description_outlined,
                                      expenseSummaryData?[
                                              'expense_description'] ??
                                          ''),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 15),
                            // getIconTextRow(Icons.description_outlined, expenseSummaryData?.expenseDescription??''),
                            Visibility(
                              visible: (expenseSummaryData?['category_name'] !=
                                      null &&
                                  expenseSummaryData!['category_name']!
                                      .isNotEmpty),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(
                                      Icons.category,
                                      expenseSummaryData?['category_name'] ??
                                          ''),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  (expenseSummaryData?['subcategory_name'] !=
                                          null &&
                                      expenseSummaryData!['subCategory_name']!
                                          .isNotEmpty),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  getIconTextRow(
                                      Icons.subtitles_outlined,
                                      expenseSummaryData?['subCategory_name'] ??
                                          ''),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  path?.length, // Number of items in the list
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.getText(path?[index]['name'] ?? '',
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
                                            (path?[index]['path'] ?? Str.errorImage),
                                        placeholder: (context, url) =>
                                            Utils.getProgressIndicator(context),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                              height: 100,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              padding: const EdgeInsets.all(0),
                                              alignment: Alignment.center,
                                              child: Utils.getText("CT",
                                                  size: 22,
                                                  color: AppC.red,
                                                  weight: FontWeight.bold));
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
                    ),
                    Visibility(
                        visible: state is TodoListLoading,
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
