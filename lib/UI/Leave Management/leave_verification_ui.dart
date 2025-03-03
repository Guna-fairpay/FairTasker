import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class LeaveVerificationUI extends StatefulWidget {
  final Map<String, dynamic> leave;
  const LeaveVerificationUI({super.key, required this.leave});

  @override
  State<LeaveVerificationUI> createState() => _LeaveVerificationUIState();
}

class _LeaveVerificationUIState extends State<LeaveVerificationUI> {
  TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> status = [
    {'status': 'Approved'},
    {'status': 'Pending'},
    {'status': 'Rejected'},
  ];
  dynamic selectedStatusNew;

  @override
  void initState() {
    super.initState();
    reasonController.text = widget.leave['reason'] ?? '';
    selectedStatusNew = status.firstWhere(
      (item) => item['status'] == widget.leave['status'],
      orElse: () => {},
    );
  }

  void _save() {
    if (selectedStatusNew == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updateLaves = {
      'id': widget.leave['id'],
      'reason': reasonController.text,
      'status': selectedStatusNew['status'],
    };
    Navigator.pop(context, updateLaves);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        foregroundColor: AppC.white,
        backgroundColor: AppC.appColor,
        title: const Text('Leave Verification'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: SafeArea(
        minimum: 10.padding,
        child: ListView(
          children: [
            Utils.dropdownBox(
              'Status',
              status,
              (value) {
                setState(() {
                  selectedStatusNew = value;
                });
              },
              labelKey: 'status',
              initialSelection: selectedStatusNew,
            ),
            const SizedBox(
              height: 20,
            ),
            Utils.getBorderedMultilineTextField(
              'Reason',
              reasonController,
              fillColor: AppC.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton(
                  text: 'Submit',
                  () => _save(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.4), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Name', widget.leave['user']['name'] ?? '',
                      icon: Icons.person),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _buildInfoRow(
                      'Leave Type', widget.leave['leave_type']['name'] ?? '',
                      icon: Icons.event_note),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _buildInfoRow('Start Date', widget.leave['start_date'] ?? "",
                      icon: Icons.date_range),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _buildInfoRow('End Date', widget.leave['end_date'] ?? '',
                      icon: Icons.date_range),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _buildInfoRow('Reason', widget.leave['reason'] ?? '',
                      icon: Icons.description),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _buildInfoRow('Status', widget.leave['status'] ?? '',
                      icon: Icons.verified),
                ],
              ),
            ),
          ],
        ),
      ),
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
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(label, weight: FontWeight.bold, size: 12),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(
                  value,
                  color: AppC.appColor,
                  weight: FontWeight.bold,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
