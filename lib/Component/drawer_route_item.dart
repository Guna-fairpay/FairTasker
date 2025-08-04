import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerRouteItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  const DrawerRouteItem({super.key, required this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.yellow,
      selectedTileColor: Colors.yellow,
      selected: true,
      leading: Icon(icon, color: AppC.appColor),
      minLeadingWidth: 10.spMin,
      title: Utils.getText(title, size: 14.spMin, weight: FontWeight.w400),
      onTap: () async {
        Scaffold.of(context).closeDrawer();
        await Future.delayed(Durations.short1);
        onTap?.call();
      },
    );
  }
}
