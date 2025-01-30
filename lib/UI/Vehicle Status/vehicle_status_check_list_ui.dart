import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class VehicleStatusChecklistUI extends StatefulWidget {
  final String? vehicleName;
  final String? vinNumber;
  final Map<String, dynamic>? vehicleStatusListData;
  final String? percentage;
  const VehicleStatusChecklistUI(
      {required this.vehicleName,
      required this.vinNumber,
      required this.vehicleStatusListData,
      required this.percentage,
      Key? key})
      : super(key: key);

  @override
  State<VehicleStatusChecklistUI> createState() =>
      _VehicleStatusChecklistUIState();
}

class _VehicleStatusChecklistUIState extends State<VehicleStatusChecklistUI> {
  late TodoViewBloc todoViewBloc;
  TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> workingHistoryDataList = [];
  Map<String, dynamic>? workingHistoryResponse;
  dynamic selectedResource;
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  TextEditingController searchController = TextEditingController();
  bool showSearchRow = false;
  List<Map<String, dynamic>>? categories = [];

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
              ..add(GetVehicleStatusCheckList(
                  vinNumber: widget.vinNumber, categoryName: null)),
            child: BlocConsumer<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
              if (state is GetVehicleStatusCheckListLoaded) {
                if (state.data != null) {
                  getFAProgressBar((state.percentage ?? 0).toString());
                  if (state.categories != null) {
                    categories = state.categories ?? [];
                  }
                }
              } else if (state is CreateCheckListTodoLoaded) {}
            }, builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        faProgressBar ?? Container(),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => ExpansionTile(
                              trailing: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: AppC.subText),
                              title: Utils.getText(
                                categories!.elementAt(index)['category_name'] ??
                                    '',
                              ),
                              children: [
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  childAspectRatio: 3,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: categories!
                                      .elementAt(index)['checklists']!
                                      .map(
                                        (item) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              activeColor: AppC().base,
                                              value: item.checked == 1,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    item.checked =
                                                        value ? 1 : 0;
                                                  });
                                                  CreateTodoParams
                                                      createTodoParams =
                                                      CreateTodoParams(
                                                    checklistId:
                                                        item.checklistId,
                                                    categoryId: item.categoryId,
                                                    checkboxValue: item.checked,
                                                    configId: item.userId,
                                                    vin: item.vin,
                                                    taskName: item.taskName ??
                                                        '${item.checklistName}-${categories!.elementAt(index)['category_name'] ?? ''}',
                                                    userId: userIdGlobal,
                                                    cohortId:
                                                        (widget.vehicleStatusListData?[
                                                                    'cohort_id'] ??
                                                                0)
                                                            .toString(),
                                                    cohortName:
                                                        widget.vehicleStatusListData?[
                                                                'cohort'] ??
                                                            '',
                                                    vehicleName:
                                                        widget.vehicleStatusListData?[
                                                                'vehicle_name'] ??
                                                            '',
                                                    vehicleImage: widget.vehicleStatusListData?[
                                                                    'images'] !=
                                                                null &&
                                                            widget
                                                                .vehicleStatusListData![
                                                                    'images']!
                                                                .isNotEmpty
                                                        ? (widget
                                                                .vehicleStatusListData?[
                                                                    'images']![
                                                                    0]
                                                                .path ??
                                                            '')
                                                        : '',
                                                  );
                                                  todoViewBloc.add(
                                                      CreateCheckListTodoEvent(
                                                          createTodoParams:
                                                              createTodoParams));
                                                }
                                              },
                                            ),
                                            Utils.getText(
                                                item.checklistName ?? ''),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                            itemCount: categories!.length,
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

  FAProgressBar? faProgressBar;
  Widget getFAProgressBar(String percentage) {
    faProgressBar = FAProgressBar(
      currentValue: double.parse(percentage),
      displayText: '%',
      backgroundColor: AppC.lightGrey,
      progressColor: AppC().base,
      animatedDuration: const Duration(seconds: 1),
      size: 15,
      maxValue: 100,
    );
    return faProgressBar!;
  }

  void doSetState() {
    setState(() {});
  }
}
