
import 'package:fairpytasker/UI/Leave%20Management/leave_management_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/manage_employees.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import '../UI/Manage Custom Data/reports/reports_view.dart';
import '../UI/Settings/google_authenticator.dart';
import '../UI/authentication_ui.dart';
import '../UI/Import Task/text_upload.dart';
import '../UI/Manage Custom Data/manage_custom_data_menu_ui.dart';
import '../UI/recurrence_Task.dart';
import '../UI/Voice To Text/UI/voice_to_text_ui.dart';
import '../Utilities/str.dart';
import '../Utilities/utils.dart';
import 'bottom_nav_for_task.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> with TickerProviderStateMixin {
  String username = '';

  @override
  void initState() {
    super.initState();
    Utils.getStringPreference('name').then((name) {
      setState(() {
        username = name.isNotEmpty ? name : '';
      });
    });
  }

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

  void navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String loginTime = DateFormat('MM-dd-yyyy HH:mm').format(now);
    return Drawer(
      backgroundColor: Colors.white,
      width: 250,
      child: Column(
        children: <Widget>[
          Column(
            children: [
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
                  child: username.isNotEmpty
                      ? Utils.getText(username[0].toUpperCase(),
                          size: 25, weight: FontWeight.bold, color: AppC.white)
                      : Container(),
                ),
                accountName: Utils.getText(
                  username,
                  size: 18,
                  weight: FontWeight.bold,
                  overFlow: TextOverflow.ellipsis,
                ),
                accountEmail: Utils.getText(getGreeting(),
                    color: Colors.black.withOpacity(0.70),
                    size: 14,
                    weight: FontWeight.w400),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildListTile(
                  icon: Icons.build,
                  title: "Manage Custom Data's",
                  onTap: () => navigateToPage(const ManageCustomDataMenuUI()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.manage_accounts,
                  title: "Manage Employees",
                  onTap: () => navigateToPage(const ManageEmployees()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.task_rounded,
                  title: "Approve Task",
                  onTap: () => context.push(TasklistUi(), fullscreenDialog: true),
                ),
                _buildDivider(),
                _buildListTile(
                    icon:  Icons.work_history,
                    title: "Leave Management",
                    onTap: () => navigateToPage(const LeaveManagementViewUI()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.file_copy,
                  title: "Reports",
                  onTap: () => navigateToPage(const ReportsView()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon:  Icons.upload,
                  title: "Import Task",
                  onTap: () => navigateToPage(const UploadText()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon:  Icons.location_on,
                  title: "Bouncie",
                  onTap: () {
                    // =>navigateToPage(const UploadText())
                  },
                ),
                /*_buildDivider(),
                _buildListTile(
                  icon:  Icons.sync,
                  title: "Recurrence Task",
                  onTap: () => navigateToPage(const RecurrenceTask()),
                ),*/
                _buildDivider(),
                _buildListTile(
                  icon:  Icons.queue_music,
                  title: "Voice To Text",
                  onTap: () => navigateToPage(const VoiceToTextUI()),
                ),
                _buildDivider(),
                _buildListTile(
                  icon:  Icons.settings,
                  title: "Settings",
                  onTap: () => navigateToPage(const GoogleAuthenticatorUI()),
                ),
                _buildDivider(),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: 5,
      thickness: 1,
      color: AppC.grey,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FutureBuilder(future: PackageInfo.fromPlatform(), builder: (context, snapshot) => Utils.getText(
            "Version: ${snapshot.data?.version}",
            color: Colors.grey.withOpacity(0.99),
          ),),
        ]),
        Container(
          decoration: BoxDecoration(
            color: AppC.appColor,
            border: Border(
              top: BorderSide(color: Colors.black.withOpacity(0.10)),
            ),
          ),
          child: Row(
            children: [
              _buildFooterButton(
                icon: Icons.home_outlined,
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
              _buildFooterButton(
                icon: Icons.power_settings_new,
                label: "Logout",
                onTap: () {
                  AskPermissionDialog.show(context, title: "Confirm logout", description: "Are you sure you want to logout?", negativeText: "No", positiveText: "Yes", onPositivePressed: () async {
                    await Authenticator.instance.logout();
                    await getIt<CommonService>().clearAll();
                    Utils.deletePreferences(key: Str.loginPrefText);
                    Utils.deletePreferences(key: Str.accessTokenPrefText);
                    Utils.deletePreferences(key: Str.userIdPrefText);
                    Session.of.clear();
                    context.pushAndRemoveUntil(const AuthenticationUI());
                  });
                  /*showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm logout'),
                        backgroundColor: AppC.white,
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Utils.getOutlinedButton('Cancel', () {
                                Navigator.of(context)
                                    .pop(); // This will dismiss the dialog when "Cancel" is pressed
                              }, verticalPadding: 0),
                              const SizedBox(
                                width: 10,
                              ),
                              Utils.getOutlinedButton('Ok', () {
                                // Perform logout logic
                                Utils.deletePreferences(key: Str.loginPrefText);
                                Utils.deletePreferences(
                                    key: Str.accessTokenPrefText);
                                Utils.deletePreferences(
                                    key: Str.userIdPrefText);

                                // Navigate to AuthenticationUI and clear navigation stack
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const AuthenticationUI(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }, verticalPadding: 0),
                            ],
                          ),
                        ],
                      );
                    },
                  );*/
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppC.appColor, size: 22),
      minLeadingWidth: 20,
      title: Utils.getText(title, color: AppC.black, size: 14),
      onTap: onTap,
    );
  }


  Expanded _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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
                size: 12,
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
