
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/category_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/attendance_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/private_rental_customers/private_rental_customers.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/ui/vendor_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Customers/customer_view_ui.dart';
import 'Location/View/location_view.dart';
import 'Vehicle Status/vehicle_status_add_ui.dart';

class ManageCustomDataMenuUI extends StatelessWidget {
  const ManageCustomDataMenuUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage CustomData Menu"),
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
        minimum: 10.sp.padding,
        child: ListView(
          children: [
            /*Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 16,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Utils.getText(
                  'Manage CustomData Menu',
                  size: 16,
                  weight: FontWeight.bold,
                ),
              ],
            ),*/
            const SizedBox(height: 10),
            _buildCard(
              icon: Icons.calendar_month_rounded,
              title: 'Attendance',
              onTap: () => context.push(const AttendanceView(), fullscreenDialog: true),
            ),
            _buildCard(
              icon: Icons.assignment,
              title: 'Task',
              onTap:() => context.push(const TaskMainPage(),),
            ),
            _buildCard(
              icon: Icons.directions_car_rounded,
              title: 'Vehicle',
              onTap: () => context.push(const VehicleMainViewUi()),
            ),
            _buildCard(
              icon: Icons.business,
              title: 'Vendor',
              onTap: () => context.push(const VendorMainUI()),
            ),
            _buildCard(
              icon: Icons.location_on,
              title: 'Location',
              onTap: () => context.push(LocationView(),)
            ),
            _buildCard(
              icon: Icons.construction,
              title: 'Parts',
              onTap:() => context.push(const PartsMainUI(),),
            ),
            _buildCard(
              icon: Icons.shopping_cart,
              title: 'Supplies',
              onTap:() => context.push(const SuppliesMainUI(),),
            ),
            _buildCard(
              icon: Icons.category,
              title: 'Category',
              onTap: () => context.push(const CategoryMainUi(), fullscreenDialog: true),
            ),
            _buildCard(
              icon: Icons.folder_open,
              title: 'SubCategory',
              onTap: () => context.push(const SubcategoryMainUi(), fullscreenDialog: true),
            ),
            _buildCard(
              icon: Icons.car_crash_sharp,
              title: 'Vehicle Status',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VehicleStatusAddUI(),
                ));
              },
            ),
            _buildCard(
              icon: Icons.group_rounded,
              title: 'Customers',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerViewUi(),
                ));
              },
            ),
            _buildCard(
              icon: Icons.group_rounded,
              title: 'Private Rental Customers',
              onTap: () => context.push(const PrivateRentalCustomers(), fullscreenDialog: true),
            ),
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
          shadowColor: Colors.white, // Subtle shadow
          surfaceTintColor: Colors.white,
          color: Colors.white, // White card background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          ),
          elevation: 2, // Slight elevation
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppC().base,
                  size: 14.sp,
                ), // Darker grey-blue for icons
                const SizedBox(width: 18),
                Expanded(
                  child: Utils.getText(
                    title,
                    size: 12.sp,
                    weight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                  color: Colors.grey[600],
                ), // Lighter grey for arrow
              ],
            ),
          ),
        ),
      ),
    );
  }
}
