
import 'package:flutter/material.dart';
import '../../../../Utilities/appC.dart';

void showHoursSummaryPopup(BuildContext context, {
  required List<Map<String, dynamic>> taskData,
  required List<Map<String, dynamic>> paymentData,
  required String name,
}) {
  final totals = _calculateTotals(taskData, paymentData, name);

  showDialog(
    context: context,
    builder: (context) => Align(
      alignment: Alignment.topCenter,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${totals['name']} - Hours Summary',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppC.appColor),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Task Table
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    // Header Row
                    const TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppC.grey,
                            width: 0.2,
                          )
                        )
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Count/Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                    // Task Data Rows
                    ...totals['tasks']!.map((task) => TableRow(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: AppC.grey,
                                width: 0.5,
                              )
                          )
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(task['name'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40,top: 8.0),
                          child: Text(task['count'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(task['amount'].toString()),
                        ),
                      ],
                    )).toList(),
                    // Total Row
                    TableRow(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: AppC.grey,
                                width: 0.5,
                              )
                          )
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(''),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30,top: 8.0),
                          child: Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (totals['totalAmount']).toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
    ),
  );
}

Map<String, dynamic> _calculateTotals(
    List<Map<String, dynamic>> taskData,
    List<Map<String, dynamic>> paymentData,
    String name,
    ) {
  final tasks = <Map<String, dynamic>>[];
  int totalAmount = 0;
  int totalCount = 0;

  final paymentMap = {
    for (var payment in paymentData.where((p) => p['type'] == 'task'))
      payment['task_name']?.toString(): _toInt(payment['amount']),
  };

  final taskGroups = <String, Map<String, dynamic>>{};
  int otherTaskCount = 0;

  for (final category in taskData) {
    final subcategories = category['subcategory'] as List<dynamic>? ?? [];

    for (final subcategory in subcategories) {
      final taskName = subcategory['sub_title']?.toString() ?? '';
      final count = _toInt(subcategory['count']);
      String? matchedTask;

      if (paymentMap.containsKey(taskName)) {
        matchedTask = taskName;
      } else {
        for (final paymentTask in paymentMap.keys) {
          if (paymentTask != null &&
              taskName.toLowerCase().contains(paymentTask.split('/')[0].toLowerCase())) {
            matchedTask = paymentTask;
            break;
          }
        }
      }

      if (matchedTask != null && paymentMap.containsKey(matchedTask)) {
        final amount = paymentMap[matchedTask];
        final key = matchedTask;

        taskGroups.update(key, (existing) => {
          'name': existing['name'],
          'count': (existing['count'] as int) + count,
          'amount': (existing['amount'] as int) + (amount! * count),
        }, ifAbsent: () => {
          'name': matchedTask!,
          'count': count,
          'amount': amount! * count,
        });
      } else {
        otherTaskCount += count;
      }
    }
  }

  if (otherTaskCount > 0) {
    final otherTaskAmount = paymentMap['Other task'] ?? 0;
    taskGroups['Other task'] = {
      'name': 'Other task',
      'count': otherTaskCount,
      'amount': otherTaskCount * otherTaskAmount,
    };
  }

  tasks.addAll(taskGroups.values);
  totalAmount = tasks.fold(0, (sum, task) => sum + (task['amount'] as int));
  totalCount = tasks.fold(0, (sum, task) => sum + (task['count'] as int));

  return {
    'tasks': tasks,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'name': name,
  };
}


int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// double _toDouble(dynamic value) {
//   if (value is double) return value;
//   if (value is int) return value.toDouble();
//   if (value is String) return double.tryParse(value) ?? 0.0;
//   return 0.0;
// }


// int _convertToInt(dynamic value) {
//   if (value is int) return value;
//   if (value is double) return value.toInt();
//   if (value is String) return int.tryParse(value) ?? 0;
//   return 0;
// }
