
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import '../Bloc/todo_view_bloc.dart';
import '../Utilities/utils.dart';
import '../Component/drawer_ui.dart';
import '../Component/header.dart';
import '../Utilities/appC.dart';
import '../Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VoiceToTextUi extends StatefulWidget {
  const VoiceToTextUi({super.key});

  @override
  State<VoiceToTextUi> createState() => _VoiceToTextUiState();
}

class _VoiceToTextUiState extends State<VoiceToTextUi> {

  late TodoViewBloc todoViewBloc;
  TextEditingController dateController = TextEditingController();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> voiceData = [];
  List<Map<String, dynamic>> filteredData = [];
  bool loading = false;

  @override
  void initState() {
    todoViewBloc = TodoViewBloc();
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    String from = selectedDateRange!.start.toString();
    String to = selectedDateRange!.end.toString();
    todoViewBloc.add(GetVoiceData(from, to));
    filteredData = voiceData;
    super.initState();
  }

  void filterDataByDateRange() {
    List<Map<String, dynamic>> result = voiceData;
    if (selectedDateRange != null) {
      result = result.where((item) {
        final dateParts = item['date']?.split(' to ');
        if (dateParts == null || dateParts.length != 2) return false;
        final startDate =
        DateTime.tryParse(dateParts[0].split('-').reversed.join('-'));
        final endDate =
        DateTime.tryParse(dateParts[1].split('-').reversed.join('-'));
        return startDate != null && endDate != null;
      }).toList();
    }
    setState(() {
      filteredData = result;
    });
  }

  String formatDate(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd').format(dateTime); // Formats the date as 'yyyy-MM-dd'
    } catch (e) {
      return ''; // In case of invalid date format
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) =>
        todoViewBloc..add(GetVoiceData(selectedDateRange!.start.toString(),
          selectedDateRange!.end.toString(),)),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
            listener: (context, state) {
              if (state is TodoListLoading) {
                loading = true;
              } else if (state is VoiceListLoaded) {
                loading = false;
                voiceData.clear();
                voiceData.addAll(state.data ?? []);
                filteredData.addAll(state.data ?? []);
              }
            },
          builder: (context,state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),const SizedBox(width: 10),
                          Utils.getText(
                            'Voice To Text',
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: DateRangeField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppC.fieldBase, width: Num.borderWidthField),
                                    borderRadius: BorderRadius.circular(Num.subradiusButton),
                                  ),
                                  label: Utils.getText('Date Range',
                                      color: AppC.grey),
                                ),
                                selectedDateRange: selectedDateRange,
                                onDateRangeSelected: (DateRange? value) {
                                  setState(() {
                                    selectedDateRange = value;
                                    String from = selectedDateRange!
                                        .start
                                        .toString();
                                    String to =
                                    selectedDateRange!.end.toString();
                                    todoViewBloc.add(GetVoiceData(
                                        from, to));

                                    filterDataByDateRange();
                                  });
                                },
                                pickerBuilder: datePickerBuilder,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filteredData.isEmpty
                            ? Center(child: Utils.getText('No data available', size: 16))
                            : ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final voiceData = filteredData[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: AppC.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Utils.getText(
                                                  voiceData['transcribed_text'] ?? '',
                                                  weight: FontWeight.bold,
                                                ),
                                                GestureDetector(
                                                    onTap: (){},
                                                    child: const Icon(
                                                        Icons.play_circle_outlined,
                                                        color: AppC.grey
                                                    )
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Utils.getText(
                                                  formatDate(voiceData['created_at'] ?? ''),
                                                  weight: FontWeight.bold,
                                                ),
                                                Utils.getText(
                                                  "${voiceData['user']['first_name'][0] ?? ''}${voiceData['user']['last_name'][0] ?? ''}",
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      disabledDates: const [],
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 338,
      displayMonthsSeparator: true,
    );
  }

}
