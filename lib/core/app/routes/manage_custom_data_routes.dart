import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/private_rental_customers/private_rental_customers.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/category_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicle%20Status/vehicle_status_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/View/location_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Customers/customer_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/attendance_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/ui/vendor_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/ui/leads_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

mixin ManageCustomDataRoutes {
  Map<String, Widget> get routes  => {
    "Attendance" :  const AttendanceView(),
    "Task" : const TaskMainPage(),
    "Vehicle" : const VehicleMainViewUi(),
    "Vendor" : const VendorMainUI(),
    "Leads" : const LeadsMainUI(),
    "Location" : const LocationView(),
    "Parts" : const PartsMainUI(),
    "Supplies" : const SuppliesMainUI(),
    "Category" : const CategoryMainUi(),
    "SubCategory" : const SubcategoryMainUi(),
    if (kDebugMode) "Vehicle Status" : const VehicleStatusAddUI(),
    if (kDebugMode) "Customers" : const CustomerViewUi(),
    "Private Rental Customers" : const PrivateRentalCustomers(),
  };

  Map<String, IconData> get icons  => {
    "Attendance" :  Remix.calendar_2_line,
    "Task" : Remix.list_check_2,
    "Vehicle" : Remix.roadster_line,
    "Vendor" : Remix.store_2_line,
    "Leads" : Remix.admin_line,
    "Location" : Iconsax.location,
    "Parts" : Remix.codepen_line,
    "Supplies" : Remix.tools_line,
    "Category" : Remix.book_shelf_line,
    "SubCategory" : Remix.file_list_2_line,
    if (kDebugMode) "Vehicle Status" : Remix.switch_line,
    if (kDebugMode) "Customers" : Remix.team_line,
    "Private Rental Customers" : Remix.team_line,
  };
}