import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';
import 'Categorys/category_view_ui.dart';
import 'Customers/customer_view_ui.dart';
import 'Location/location_view_ui.dart';
import 'Parts/part_view_ui.dart';
import 'Sub Category/subcategory_view_ui.dart';
import 'Supplies/supplies_view_ui.dart';
import 'Task/task_view_ui.dart';
import 'Vehicle Status/vehicle_status_add_ui.dart';
import 'Vehicles/vehicle_view_ui.dart';
import 'Vendor/vendor_view_ui.dart';

class ManageCustomdataMenuUI extends StatefulWidget {
  const ManageCustomdataMenuUI({super.key});

  @override
  State<ManageCustomdataMenuUI> createState() => _ManageCustomdataMenuUIState();
}

class _ManageCustomdataMenuUIState extends State<ManageCustomdataMenuUI> {
  @override
  void initState() {
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
                Utils.getText('Manage CustomData Menu',
                    size: 16, weight: FontWeight.bold),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildCard(
              icon: Icons.assignment,
              title: 'Task',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TaskViewUI()));

                ///TaskViewUI//CreateTaskUI
              },
            ),
            _buildCard(
              icon: Icons.directions_car_rounded,
              title: 'Vehicle',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VehicleUIs()));

                ///VehicleUI///VehicleUIs
              },
            ),
            _buildCard(
              icon: Icons.business,
              title: 'Vendor',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VendorViewUI()));
              },
            ),
            // _buildCard(
            //   icon: Icons.add_business,
            //   title: 'Vendor Type',
            //   onTap: () async {
            //     await Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const VendorTypeUI()));
            //   },
            // ),
            _buildCard(
              icon: Icons.location_on,
              title: 'Location',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LocationViewUI()));

                ///LocationUI ///LocationViewUI
              },
            ),
            _buildCard(
              icon: Icons.construction,
              title: 'Parts',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PartViewUI()));

                ///PartsUI///PartViewUI
              },
            ),
            _buildCard(
              icon: Icons.shopping_cart,
              title: 'Supplies',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SuppliesViewUI()));

                ///SupplyUI///SuppliesViewUI
              },
            ),
            _buildCard(
              icon: Icons.category,
              title: 'Category',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CategoryViewUi()));

                ///CategoryViewUi///CreateTaskUI
              },
            ),
            _buildCard(
              icon: Icons.folder_open,
              title: 'SubCategory',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SubcategoryViewui()));

                ///SubCategoryUI///SubcategoryViewui
              },
            ),
            _buildCard(
              icon: Icons.car_crash_sharp,
              title: 'Vehicle Status',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VehicleStatusAddUI()));

                ///VehicleStatusAddUI///CreateTaskUI
              },
            ),
            _buildCard(
              icon: Icons.group_rounded,
              title: 'Customers',
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CustomerViewUi()));

                ///CustomerViewUi
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
          shadowColor: Colors.white, // Subtle shadow
          surfaceTintColor: Colors.white,
          color: Colors.white, // White card background
          shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.grey[200]!, width: 1.0),
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
