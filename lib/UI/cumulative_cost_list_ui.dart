import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/UI/Expense/add_expense_ui.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CumulativeCostListUI extends StatefulWidget {
  /*final String? vehicleName;
  final String? vin;*/
  final Map<String, dynamic>? vehicleStatusListData;
  final CreateExpenseFieldData? createExpenseFieldData;

  const CumulativeCostListUI(
      {Key? key,
      required this.vehicleStatusListData,
      required this.createExpenseFieldData})
      : super(key: key);

  @override
  State<CumulativeCostListUI> createState() => _CumulativeCostListUIState();
}

class _CumulativeCostListUIState extends State<CumulativeCostListUI> {
  late TodoViewBloc todoViewBloc;
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> cceList = [];
  num totalAmount = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        // appBar: AppBar(
        //     centerTitle: true,
        //     elevation: 0,
        //     backgroundColor: AppC.trans,
        //     leading: IconButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         icon: const Icon(
        //           Icons.arrow_back_sharp,
        //           color: AppC.black,
        //         )),
        //     title: Utils.getText('${widget.vehicleName}-${widget.vin}',
        //         size: 18, weight: FontWeight.w700)),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => todoViewBloc
                  ..add(GetCumulativeList(
                      vin: widget.vehicleStatusListData!['vin']!)),
              ),
              BlocProvider(
                create: (context) =>
                    vehicleDataBloc..add(const VehicleInitial()),
              ),
            ],
            child: MultiBlocListener(
                listeners: [
                  BlocListener<TodoViewBloc, TodoViewState>(
                    listener: (context, state) async {
                      if (state is CumulativeCostLoaded) {
                        cceList = state.cumulativeCostExpensesList ?? [];
                        totalAmount = cceList.fold(
                            0, (sum, e) => sum + e['expense_amount']);
                        debugPrint(cceList.length.toString());
                      }
                    },
                  ),
                  BlocListener<VehicleDataBloc, VehicleDataState>(
                    listener: (context, state) async {
                      if (state is VehicleDataInitial) {
                        todoViewBloc.add(GetCumulativeList(
                            vin: widget.vehicleStatusListData!['vin']!));
                      }
                    },
                  )
                ],
                child: BlocBuilder<TodoViewBloc, TodoViewState>(
                  builder: (context, state) {
                    return SafeArea(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_sharp,
                                          color: AppC.black,
                                        )),
                                    Expanded(
                                      child: Utils.getText(
                                          '${widget.vehicleStatusListData!['vehicle_name']}-${widget.vehicleStatusListData!['vin']}',
                                          size: 18,
                                          weight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Utils.getOutlinedButton('Add Expense',
                                        () async {
                                      bool result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddExpenseUI(
                                                    createExpenseFieldData: widget
                                                        .createExpenseFieldData,
                                                    vehicleStatusListData: widget
                                                        .vehicleStatusListData)),
                                      );
                                      if (result) {
                                        todoViewBloc.add(GetCumulativeList(
                                            vin: widget.vehicleStatusListData![
                                                'vin']!));
                                      }
                                    }, verticalPadding: 0),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cceList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: Utils.getBoxDecoration(),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Utils.getText(cceList[index]
                                                    ['expense_date'] ??
                                                ''),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Utils.getText(cceList[index]
                                                              ['category']
                                                          ?.name ??
                                                      ''),
                                                  Utils.getRichText(
                                                      cceList[index][
                                                                  'subcategory']
                                                              ?.name ??
                                                          '',
                                                      AppC.text,
                                                      cceList[index]['expense_description'] !=
                                                                  null &&
                                                              cceList[index][
                                                                      'expense_description']!
                                                                  .isNotEmpty
                                                          ? ' (${cceList[index]['expense_description']})'
                                                          : '',
                                                      AppC.blue),
                                                ],
                                              ),
                                            ),
                                            Utils.getText(
                                                '\$${cceList[index]['expense_amount']}'),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Utils.getAlertDialog(context,
                                                      () {
                                                    // vehicleDataBloc.add(
                                                    //     DeleteExpense(
                                                    //         id: cceList[index]
                                                    //                 ['id']!
                                                    //             .toString()));
                                                    // Navigator.of(context).pop();
                                                  },
                                                      content:
                                                          'Are you sure want to delete a Expense?');
                                                },
                                                child: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: AppC.red))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Utils.getText('Total: \$$totalAmount',
                                    weight: FontWeight.bold, size: 16),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: state is TodoListLoading,
                              child: Center(
                                  child: Utils.getProgressIndicator(context)))
                        ],
                      ),
                    );
                  },
                ))));
  }
}
