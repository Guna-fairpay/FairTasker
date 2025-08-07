import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/manage_custom_data_menu_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_view.dart';
import 'package:fairpytasker/UI/Manage%20Employees/manage_employees.dart';
import 'package:fairpytasker/UI/Settings/google_authenticator.dart';
import 'package:fairpytasker/UI/approve_task/ui/approve_task_main_ui.dart';
import 'package:fairpytasker/UI/archive_task/archive_task_main/ui/archive_task_main_ui.dart';
import 'package:fairpytasker/UI/authentication/authentication_ui.dart';
import 'package:fairpytasker/UI/bouncie/bouncie_main_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/import_task/import_task_main_ui.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/ui/leave_view_main_page.dart';
import 'package:fairpytasker/UI/offshore_report/base_page/ui/offshore_report_base_page.dart';
import 'package:fairpytasker/UI/release_notes/release_notes_viewer.dart';
import 'package:fairpytasker/UI/voice_to_text/ui/voice_to_text_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:r_icon_pro/r_icon_pro.dart';
import 'package:remixicon/remixicon.dart';

mixin DrawerRoutes {

  List<String> get userId => ['20','31','3','17','2','1'];
  List<String> get approveTask => ['3','17','1','2','6'];
  List<String> get archiveTask => ['1', '2', '3'];

  Map<String, Widget> get routes => {
    "Manage Custom Data's" : const ManageCustomDataMenuUI(),
    if (getIt<CommonService>().isAdmin) "Manage Employees" : const ManageEmployees(),
    if(approveTask.contains(Session.of.getString(Str.userIdPrefText))) "Approve Task" : const ApproveTaskMainUI(),
    if(archiveTask.contains(Session.of.getString(Str.userIdPrefText)))  "Archive Task" : const ArchiveTaskMainUI(),
    "Leave Management" : const LeaveViewMainPage(),
    "Reports" : const ReportsView(),
    if (getIt<CommonService>().hasFairTechEOD) "Offshore Report" : const OffshoreReportBasePage(),
    if(userId.contains(Session.of.getString(Str.userIdPrefText))) "Import Task" : const ImportTaskMainUi(),
    "Bouncie" : const BouncieMainUi(),
    "Voice To Text" : const VoiceToTextUI(),
    if (kDebugMode) "Settings" : const GoogleAuthenticatorUI()
  };

  Map<String, IconData> get icons => {
    "Manage Custom Data's" : Remix.honour_line,
    "Manage Employees" : Remix.user_community_line,
    "Approve Task" : RIcon.Checklist_Minimalistic,
    "Archive Task" : RIcon.Archive_Minimalistic,
    "Leave Management" : RIcon.History_2,
    "Reports" : RIcon.Chart_Square,
    "Offshore Report" : RIcon.Pie_Chart_3,
    "Import Task" : RIcon.Upload_Minimalistic,
    "Bouncie" : RIcon.Map_Point_Wave,
    "Voice To Text" : RIcon.Music_Library_2,
    "Settings" : RIcon.Settings_Minimalistic
  };

  Widget buildFooter(BuildContext context) {
    return Column(
      children: [
        Padding(padding: 10.spMin.padding, child: FutureBuilder(future: PackageInfo.fromPlatform(), builder: (context, snapshot) => GestureDetector(
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            await Future.delayed(Durations.short4);
            ReleaseNotesViewer.show(context, getIt<CommonService>().releaseNotes?['data']?['notes']);
          },
          child: CompactText(
            "App Version: ${snapshot.data?.version} ${flavor.isDebug ? "Dev" : ""}",
            color: Colors.grey.withValues(alpha: 0.99),
          ),
        ))),
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

  Expanded _buildFooterButton({required IconData icon, required String label, required VoidCallback onTap,}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: 7.spMin.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              Utils.getText(
                label,
                size: 14.spMin,
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