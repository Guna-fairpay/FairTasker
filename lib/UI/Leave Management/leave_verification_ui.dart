
import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class LeaveVerificationUI extends StatefulWidget {
  final Map<String,dynamic>leave;
  const LeaveVerificationUI({super.key,required this.leave});

  @override
  State<LeaveVerificationUI> createState() => _LeaveVerificationUIState();
}

class _LeaveVerificationUIState extends State<LeaveVerificationUI> {

  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController reasonController=TextEditingController();
  TextEditingController approvalReasonController=TextEditingController();
  TextEditingController typeController=TextEditingController();
  TextEditingController statusController=TextEditingController();
  List<Map<String,dynamic>> status = [
    {'status':'Approved'},
    {'status':'Pending'},
    {'status':'Rejected'},
  ];
  dynamic selectedStatusNew;

  @override
  void initState() {
    super.initState();
    startDateController.text=widget.leave['start_date']??'';
    endDateController.text =widget.leave['end_date']??'';
    reasonController.text=widget.leave['reason']??'';
    nameController.text=widget.leave['user']['name']??'';
    typeController.text=widget.leave['leave_type']['name']??'';
    statusController.text=widget.leave['status']??'';
    selectedStatusNew = status.firstWhere(
          (item) => item['status'] == widget.leave['status'],
      orElse: () => {},
    );
  }

  void _save() {
    setState(() {
      // isVehicleFieldEmpty=vehicleController.text.isEmpty;
      // isCustomerFieldEmpty=customerController.text.isEmpty;
    });
    if (selectedStatusNew==null)
    {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updateLaves = {
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'reason': reasonController.text,
      'type': typeController.text,
      'name':nameController.text,
      'status':selectedStatusNew?? '',
    };
    Navigator.pop(context, updateLaves);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:20.0,right: 20,bottom: 20,top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [ GestureDetector(onTap: (){
                  Navigator.pop(context);
                },
                    child: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 10,),
                  Utils.getText('Approve/Reject Leave',size: 20,weight: FontWeight.bold),
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Utils.dropdownBox(
                      'Status',
                      status,
                          (value) {
                        setState(() {
                          selectedStatusNew = value;
                        });
                      }, labelKey: 'status',
                      initialSelection: selectedStatusNew,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Utils.getBorderedMultilineTextField(
                  'Reason',
                  approvalReasonController,
                  fillColor: AppC.white,),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    child: Utils.getAddFilledButton(
                      'Submit',
                          () {
                            _save();
                      },
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(20.0), // Increased padding for better spacing
            decoration: BoxDecoration(
              color: Colors.white, // Neutral background color
              borderRadius: BorderRadius.circular(16), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: Colors.blueAccent.withOpacity(0.4), width: 1), // Border with accent color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Name', nameController.text, icon: Icons.person),
                Divider(thickness: 1, color: Colors.grey[300]), // Divider between rows
                _buildInfoRow('Leave Type', typeController.text, icon: Icons.event_note),
                Divider(thickness: 1, color: Colors.grey[300]),
                _buildInfoRow('Start Date', startDateController.text, icon: Icons.date_range),
                Divider(thickness: 1, color: Colors.grey[300]),
                _buildInfoRow('End Date', endDateController.text, icon: Icons.date_range),
                Divider(thickness: 1, color: Colors.grey[300]),
                _buildInfoRow('Reason', reasonController.text, icon: Icons.description),
                Divider(thickness: 1, color: Colors.grey[300]),
                _buildInfoRow('Status', statusController.text, icon: Icons.verified),
              ],
            ),
          ),
          ],
          ),
        ),
      ),

      drawer: const DrawerView(),
    );
  }
  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
            Column(
              children: [
                Icon(icon, color: Colors.blueAccent[100], size: 20),
              ],
            ),
          const SizedBox(width: 8),
          SizedBox(width: 100,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(label, weight: FontWeight.bold, size: 12),
              ],
            ),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(value,color: AppC.appColor,weight: FontWeight.bold,size: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
