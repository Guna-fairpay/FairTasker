import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/routes/drawer_routes.dart';
import 'package:fairpytasker/Component/drawer_route_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget with DrawerRoutes {
  const DrawerView({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 12
        ? 'Hi, Good Morning'
        : hour < 16
        ? 'Hi, Good Afternoon'
        : hour < 20
        ? 'Hi, Good Evening'
        : 'Hi, Good Night';
  }

  void navigateToPage(BuildContext context,Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.spMin,
      width: context.width * 0.65,
      shadowColor: AppC.appColor,
      surfaceTintColor: AppC.appbgColor,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(26.spMin))),
      child: Container(
        decoration: const BoxDecoration(color: AppC.white),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color:AppC.appColor),
                ),
              ),
              margin: EdgeInsets.zero,
              currentAccountPicture: CircleAvatar(
                radius: 25,
                backgroundColor: AppC.appColor,
                child: Session.of.getString("name").isNotNullOrEmpty
                    ? Utils.getText((Session.of.getString("name")?[0] ?? "").toUpperCase(),
                    size: 25, weight: FontWeight.bold, color: AppC.white)
                    : Container(),
              ),
              accountName: Utils.getText(
                Session.of.getString("name") ?? "",
                size: 18,
                weight: FontWeight.bold,
                overFlow: TextOverflow.ellipsis,
              ),
              accountEmail: Utils.getText(getGreeting(),
                  color: Colors.black.withValues(alpha: 0.70),
                  size: 14,
                  weight: FontWeight.w400),
            ),
            Flexible(child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                itemBuilder: (context, index) {
                final entry = routes.entries.elementAt(index);
                return DrawerRouteItem(title: entry.key, icon: icons[entry.key], onTap: () => context.push(entry.value, fullscreenDialog: true));
                },
                separatorBuilder: (context, index) => const Divider(height: Num.borderWidthThinField, thickness: Num.borderWidthThinField, color: AppC.borderColor),
                itemCount: routes.entries.length)),
            SafeArea(child: buildFooter(context)),
          ],
        ),
      ),
    );
  }
}
