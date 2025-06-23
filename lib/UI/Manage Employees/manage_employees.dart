import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/UI/employee_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Employees/department/department_listing/ui/department_view_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/permission/permission_listing/ui/permission_listing_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/role/role_view_page/ui/role_view_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';


class ManageEmployees extends StatelessWidget {
  const ManageEmployees({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        title: const Text("Manage Employees"),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(color: AppC.white),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: 10.spMin.horizontalPadding,
          children: [
            const SizedBox(
              height: 5,
            ),
            _buildCard(
              icon: Iconsax.people,
              title: 'Employees',
              onTap: () => context.push(const EmployeeMainPage())),
            if (getIt<CommonService>().isAdmin || kDebugMode)
              ...[
                _buildCard(
                  icon: Iconsax.briefcase, // or Icons.apartment, Icons.business_center, Icons.people_alt
                  title: 'Departments',
                  onTap:  ()=> context.push(const DepartmentViewMainUI())),
                // _buildCard(
                //   icon: Icons.badge_outlined,
                //   title: 'Roles',
                //   onTap: () async {
                //     await Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => const RoleViewUI()));
                //   },
                // ),
                _buildCard(
                  icon: Iconsax.personalcard,
                  title: 'Roles',
                  onTap: ()=> context.push(const RoleViewMainUI())),
                _buildCard(
                  icon: Iconsax.shield_tick,
                  title: 'Permissions',
                  onTap: ()=> context.push(const PermissionListingMainUI())),
              ],
          ],
        ),
      ),
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
            padding: 10.spMin.padding,
            child: Row(
              children: [
                Icon(icon, color: AppC.appColor), // Darker grey-blue for icons
                const SizedBox(width: 18),
                Expanded(
                  child: CompactText(title, fontWeight: FontWeight.w400, color: Colors.black87),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: Colors.grey[600]), // Lighter grey for arrow
              ],
            ),
          ),
        ),
      ),
    );
  }
}
