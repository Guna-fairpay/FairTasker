
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
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
              icon: Iconsax.calendar_1,
              title: 'Attendance',
              onTap: () => context.push(const AttendanceView(), fullscreenDialog: true),
            ),
            _buildCard(
              icon: Iconsax.note_1,
              title: 'Task',
              onTap:() => context.push(const TaskMainPage(),),
            ),
            _buildCard(
              icon: Iconsax.car,
              title: 'Vehicle',
              onTap: () => context.push(const VehicleMainViewUi()),
            ),
            _buildCard(
              icon: Iconsax.shop,
              title: 'Vendor',
              onTap: () => context.push(const VendorMainUI()),
            ),
            _buildCard(
              icon: Iconsax.location,
              title: 'Location',
              onTap: () => context.push(const LocationView())
            ),
            _buildCard(
              icon: Iconsax.magicpen,
              title: 'Parts',
              onTap:() => context.push(const PartsMainUI(),),
            ),
            _buildCard(
              icon: Iconsax.broom,
              title: 'Supplies',
              onTap:() => context.push(const SuppliesMainUI(),),
            ),
            _buildCard(
              icon: Iconsax.category,
              title: 'Category',
              onTap: () => context.push(const CategoryMainUi(), fullscreenDialog: true),
            ),
            _buildCard(
              icon: Iconsax.tag_2,
              title: 'SubCategory',
              onTap: () => context.push(const SubcategoryMainUi(), fullscreenDialog: true),
            ),
            if (kDebugMode)
            _buildCard(
              icon: Iconsax.status,
              title: 'vehicle_status',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VehicleStatusAddUI(),
                ));
              },
            ),
            if (kDebugMode)
            _buildCard(
              icon: Iconsax.people,
              title: 'Customers',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerViewUi(),
                ));
              },
            ),
            _buildCard(
              icon: Iconsax.people,
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
    return Card(
      shadowColor: Colors.white, // Subtle shadow
      surfaceTintColor: Colors.white,
      color: Colors.white, // White card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.spMin), // Slightly rounded corners
      ),
      elevation: 2, // Slight elevation
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: RowTile(
          onTap: onTap,
          spacing: 10.spMin,
          expandTitle: true,
          leading: Icon(
            icon,
            color: AppC.appColor,
            size: 15.spMin,
          ),
          title: CompactText(
            title,
            color: Colors.black87,
          ),
          trailing: Icon(
            Iconsax.arrow_right_3,
            size: 13.spMin,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
