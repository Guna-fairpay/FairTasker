import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/UI/employee_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Employees/department/department_listing/ui/department_view_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/permission/permission_listing/ui/permission_listing_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/role/role_view_page/ui/role_view_main_ui.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin ManageEmployeesRoutes {
  Map<String, Widget> get routes => {
    "Employees" : const EmployeeMainPage(),
    if (getIt<CommonService>().isAdmin || kDebugMode) "Departments" : const DepartmentViewMainUI(),
    if (getIt<CommonService>().isAdmin || kDebugMode) "Roles" : const RoleViewMainUI(),
    if (getIt<CommonService>().isAdmin || kDebugMode) "Permissions" : const PermissionListingMainUI()
  };

  Map<String, IconData> get icons => {
    "Employees" : Remix.shield_user_line,
    "Departments" : Remix.briefcase_2_line,
    "Roles" : Remix.id_card_line,
    "Permissions" : Remix.shield_check_line
  };
}