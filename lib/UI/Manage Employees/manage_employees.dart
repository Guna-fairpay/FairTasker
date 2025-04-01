import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/str.dart';
import '../../Utilities/utils.dart';
import 'Departments/department_view_ui.dart';
import 'Employees/employees_view_ui.dart';
import 'Permissions/permissions_view_ui.dart';
import 'Roles/role_view_ui.dart';

class ManageEmployees extends StatefulWidget {
  const ManageEmployees({super.key});

  @override
  State<ManageEmployees> createState() => _ManageEmployeesState();
}

class _ManageEmployeesState extends State<ManageEmployees> {
  String? userRole;

  @override
  void initState() {
    Utils.getStringListPreference(Str.rolePrefText).then((role) {
      setState(() {
        userRole = role
            .first; // Assuming role is a List<String> and fetching the first value
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 16,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Manage Employees',
                    size: 16, weight: FontWeight.bold),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _buildCard(
              icon: Icons.groups,
              title: 'Employees',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmployeesViewUI()));
              },
            ),
            _buildCard(
              icon: Icons
                  .business_center, // or Icons.apartment, Icons.business_center, Icons.people_alt
              title: 'Departments',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DepartmentViewUI()));
              },
            ),
            if (userRole == 'Admin')
              _buildCard(
                icon: Icons.badge_outlined,
                title: 'Roles',
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RoleViewUI()));
                },
              ),
            if (userRole == 'Admin')
              _buildCard(
                icon: Icons
                    .lock_person, // or Icons.verified_user, Icons.supervisor_account
                title: 'Permissions',
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PermissionsViewUI()));
                },
              ),
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shadowColor: Colors.grey[300], // Subtle shadow
          surfaceTintColor: Colors.white,
          color: Colors.white, // White card background
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey[200]!, width: 1.0),
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          ),
          elevation: 2, // Slight elevation
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Row(
              children: [
                Icon(icon,
                    color: AppC().base, size: 14), // Darker grey-blue for icons
                const SizedBox(width: 18),
                Expanded(
                  child: Utils.getText(title,
                      size: 12, weight: FontWeight.w400, color: Colors.black87),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[600]), // Lighter grey for arrow
              ],
            ),
          ),
        ),
      ),
    );
  }
}
