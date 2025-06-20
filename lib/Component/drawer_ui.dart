import 'package:fairpytasker/UI/Manage%20Employees/manage_employees.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_ui.dart';
import 'package:fairpytasker/UI/approve_task/ui/approve_task_main_ui.dart';
import 'package:fairpytasker/UI/bouncie/bouncie_main_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/import_task/import_task_main_ui.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/ui/leave_view_main_page.dart';
import 'package:fairpytasker/UI/offshore_report/base_page/ui/offshore_report_base_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:r_icon_pro/r_icon_pro.dart';
import '../UI/Manage Custom Data/reports/reports_view.dart';
import '../UI/Settings/google_authenticator.dart';
import '../UI/authentication/authentication_ui.dart';
import '../UI/Manage Custom Data/manage_custom_data_menu_ui.dart';
import '../UI/Voice To Text/UI/voice_to_text_ui.dart';
import '../Utilities/str.dart';
import '../Utilities/utils.dart';
import 'bottom_nav_for_task.dart';

class DrawerView extends StatelessWidget {
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
    List<String> userId = ['20','31','3','17','2','1'];
    List<String> approveTask = ['3','17','1','2','6'];
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildListTile(
                    context,
                    icon: RIcon.Archive_Minimalistic,
                    title: "Manage Custom Data's",
                    onTap: () => context.push(const ManageCustomDataMenuUI(), fullscreenDialog: true),
                  ),
                  if (getIt<CommonService>().isAdmin)
                    ...[
                      _buildDivider(),
                      _buildListTile(
                        context,
                        icon: RIcon.Users_Group_Rounded,
                        title: "Manage Employees",
                        onTap: () => context.push(const ManageEmployees(), fullscreenDialog: true),
                      ),
                    ],
                  _buildDivider(),
                  if(approveTask.contains(Session.of.getString(Str.userIdPrefText)))
                  _buildListTile(
                    context,
                    icon: RIcon.Checklist_Minimalistic,
                    title: "Approve Task",
                    onTap: () => context.push(const ApproveTaskMainUI()),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                      icon:  RIcon.History_2,
                      title: "Leave Management",
                      onTap: () => navigateToPage(context, const LeaveViewMainPage()),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: RIcon.Chart_Square,
                    title: "Reports",
                    onTap: () => navigateToPage(context, const ReportsView()),
                  ),
                  if (getIt<CommonService>().hasFairTechEOD)
                    ...[
                      _buildDivider(),
                      _buildListTile(
                        context,
                        icon: RIcon.Pie_Chart_3,
                        title: "Offshore Report",
                        onTap: () => navigateToPage(context, const OffshoreReportBasePage()),
                      ),
                    ],
                  _buildDivider(),
                  if(userId.contains(Session.of.getString(Str.userIdPrefText)))
                  _buildListTile(
                    context,
                    icon:  RIcon.Upload_Minimalistic,
                    title: "Import Task",
                    onTap: () => context.push(const ImportTaskMainUi(), fullscreenDialog: true),
                    // onTap: () => navigateToPage(context, const UploadText()),
                  ),
                  if (kDebugMode)
                    ...[
                      _buildDivider(),
                      _buildListTile(
                        context,
                        icon:  RIcon.Map_Point_Wave,
                        title: "Bouncie",
                        onTap: () => context.push(const BouncieMainUi(), fullscreenDialog: true),
                      ),
                    ],
                  /*_buildDivider(),
                  _buildListTile(
                    icon:  Icons.sync,
                    title: "Recurrence Task",
                    onTap: () => navigateToPage(const RecurrenceTask()),
                  ),*/
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon:  RIcon.Music_Library_2,
                    title: "Voice To Text",
                    onTap: () => context.push(const VoiceToTextUI(), fullscreenDialog: true),
                  ),
                  if (kDebugMode)
                    ...[
                      _buildDivider(),
                      _buildListTile(
                        context,
                        icon:  RIcon.Settings_Minimalistic,
                        title: "Settings",
                        onTap: () => context.push(const GoogleAuthenticatorUI(), fullscreenDialog: true),
                      ),
                    ],
                  _buildDivider(),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: Num.borderWidthThinField,
      thickness: Num.borderWidthThinField,
      color: AppC.borderColor,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Padding(padding: 10.sp.padding, child: FutureBuilder(future: PackageInfo.fromPlatform(), builder: (context, snapshot) => Utils.getText(
          "Version: ${snapshot.data?.version} ${flavor.isDebug ? "Dev" : ""}",
          color: Colors.grey.withValues(alpha: 0.99),
        ),)),
        Container(
          decoration: const BoxDecoration(
            color: AppC.appColor,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildFooterButton(
                  icon: RIcon.Home_,
                  label: "Home",
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationForTaskView(
                          selectedIndex: 0,
                          message: '',
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                VerticalDivider(
                  color: AppC.white,
                  thickness: 0.5,
                  width: 0.5,
                  endIndent: 10.sp,
                  indent: 10.sp,
                ),
                _buildFooterButton(
                  icon: RIcon.Exit,
                  label: "Logout",
                  onTap: () {
                    AskPermissionDialog.show(context, title: "Confirm logout", description: "Are you sure you want to logout?", negativeText: "No", positiveText: "Yes", onPositivePressed: () async {
                      await Future.microtask(Authenticator.instance.logout);
                      await getIt<CommonService>().clearAll();
                      Utils.deletePreferences(key: Str.loginPrefText);
                      Utils.deletePreferences(key: Str.accessTokenPrefText);
                      Utils.deletePreferences(key: Str.userIdPrefText);
                      await Session.of.clear();
                      context.pushAndRemoveUntil(const AuthenticationUI());
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap,}) {
    return ListTile(
      leading: Icon(icon, color: AppC.appColor),
      minLeadingWidth: 10.sp,
      title: Utils.getText(title, size: 12.sp, weight: FontWeight.w400),
      onTap: () {
        onTap.call();
        Scaffold.of(context).closeDrawer();
      },
    );
  }

  Expanded _buildFooterButton({required IconData icon, required String label, required VoidCallback onTap,}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              Utils.getText(
                label,
                size: 12.sp,
                color: Colors.white,
                weight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
