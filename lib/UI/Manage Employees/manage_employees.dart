import 'package:fairpytasker/core/app/routes/manage_employees_routes.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/submenu_list_item.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ManageEmployees extends StatelessWidget with ManageEmployeesRoutes {
  const ManageEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: CompactAppBar(
        titleText: "Manage Employees",
        onClose: context.pop,
      ),
      body: SafeArea(
        minimum: 10.spMin.padding,
        child: ListView.separated(
            itemBuilder: (context, index) {
              final entry = routes.entries.elementAt(index);
              return SubmenuListItem(
                title: entry.key,
                icon: icons[entry.key],
                onTap: () => context.push(entry.value, fullscreenDialog: true),
              );
            },
            separatorBuilder: (context, index) => 5.spMin.height,
            itemCount: routes.entries.length),
      ),
    );
  }
}
