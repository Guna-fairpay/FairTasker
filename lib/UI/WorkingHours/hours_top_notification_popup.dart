

import 'package:flutter/material.dart';
import '../../Utilities/Utils.dart';

class TopNotificationPopup {

  static void show(BuildContext context, {
    required List<dynamic> dataList,
    required String userName,
    required String selectedDateRange,
  }) {
    _showTopNotification(context, dataList, userName, selectedDateRange);
  }





 static void _showTopNotification(BuildContext context, List<dynamic> dataList, String userName, String selectedDateRange)
 {
   String formatDurationToHM(String durationString) {
     try {
       List<String> parts = durationString.split(':');
       if (parts.length == 3) {
         int hours = int.parse(parts[0]);
         int minutes = int.parse(parts[1]);
         return '${hours}h ${minutes}m';
       } else {
         return 'Invalid format'; // Or handle the error as needed
       }
     } catch (e) {
       return 'Invalid format'; // Handle parsing errors
     }
   }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog( // Use Dialog for more customization
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important for fitting content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Utils.getText(userName, weight: FontWeight.bold, size: 18),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {

                        },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Utils.getText(selectedDateRange.toString(), size: 14),
                SizedBox(height: 16),
                Container(
                  child: ListView.builder(itemCount: dataList.length,
                      itemBuilder: (context, index)
                  {
                    final data = dataList[index];

                    DataTable( // Use DataTable for tabular data
                      columns: const <DataColumn>[

                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('${data['date']}')),
                            DataCell(Text(data['start_time'].substring(0, 5) ?? '')),
                            DataCell(Text(data['end_time'] ?? '')),
                            DataCell(Text('10h45m')),
                            DataCell(Text(formatDurationToHM(data['total_hours']))),
                          ],
                        ),
                      ],
                    );
                  }),
                ),

              ],
            ),
          ),
        );
      },
    );
 }
}
