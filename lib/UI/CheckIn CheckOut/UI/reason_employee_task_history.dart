
import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class ReasonEmployeeTaskHistory extends StatelessWidget {
  const ReasonEmployeeTaskHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(7, 90, 51, 1.0),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Utils.getText("Drop Car Rental",color: Colors.white, size: 14, weight: FontWeight.bold),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(leading: Icon(Icons.calendar_month),title: Row(
            children: [Utils.getText("10-04-2024"),SizedBox(width: 5,),Utils.getText("09:30 AM")],
          ),
          ),
          ListTile(leading: Icon(Icons.person_2_outlined),title: Utils.getText("HM"),),
          ListTile(leading: Icon(Icons.directions_car_filled_outlined),title: Utils.getText("2019 CHEROLET SPARK LS"),),
          ListTile(leading: Icon(Icons.location_history),title: Utils.getText("DFW Airport"),),
          ListTile(leading: Icon(Icons.sticky_note_2_outlined),title:  Utils.getText("07:30"),),
          ListTile(leading: Icon(Icons.location_on_outlined),title: Utils.getText("No Odometer"),),
          ListTile(leading: Utils.getText("Reservation No-6477777",color: AppC.red),),
        ],
      ),
    );
  }

}
