import 'package:fairpytasker/Bloc/header_bloc.dart';
import 'package:fairpytasker/Event/header_events.dart';
import 'package:fairpytasker/State/header_states.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/resource_ui.dart';
import 'package:fairpytasker/UI/dialog/popup/branch_popup.dart';
import 'package:fairpytasker/UI/resources_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utilities/str.dart';
import 'bottom_nav_for_task.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HeaderBloc()..add(HeaderInitialEvent()),
      child: BlocListener<HeaderBloc, HeaderState>(
        listener: (context, state) {
          if (state is HeaderLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is HeaderErrorState) {
              Console.of.error(state.message);
            }
          }
        },
        child: AppBar(
          elevation: 0,
          leadingWidth: 0,
          backgroundColor: AppC.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: Scaffold.of(context).openDrawer,
                child: SvgPicture.asset(
                  Assets.hamburgerIcon,
                  color: AppC().base,
                ),
                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const BottomNavigationForTaskView(
                          selectedIndex: 0,
                          message: '',
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    Assets.favicon,
                    width: 24.sp,
                    height: 24.sp,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const Spacer(),
              // if (userRole == 'Admin' || userId == '3')
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const TasklistUi()));
              //     },
              //     child: const Icon(
              //       Icons.pending_actions_rounded,
              //       color: AppC.appColor,
              //     ),
              //   ),
              // const SizedBox(width: 10),
              /*InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>TasklistUi()));
                      },
                      child: const Icon(
                        Icons.pending_actions_rounded,
                        color: AppC.appColor,
                      ),
                    ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ChatPreviewListUI(),
                        ),
                      );
                    },
                    child: Image.asset(
                      Assets.icChat,
                      width: 20,
                      height: 20,
                      fit: BoxFit.fitHeight,
                      color: AppC().base,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const BottomNavigationForTaskView(selectedIndex: 2, message: '',),
                        ),
                      );
                    },
                    child: Container(
                      decoration: Utils.getBoxDecoration(),
                      child: Utils.getText(' 0/0 '),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      showMenu<Map<String, dynamic>>(
                        color: Colors.white,
                        context: context,
                        position: const RelativeRect.fromLTRB(10, 50, 0, 50),
                        items: branch.map((item) {
                          bool isSelected = selectedValue == item;
                          return PopupMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2), // Reduced vertical margin
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    6), // Smaller border radius
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : [],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10), // Reduced padding
                              child: Center(
                                child: Text(
                                  item['city'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Smaller font size
                                    color:
                                        isSelected ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            selectedValue = value;
                            Utils.setIntPreference(
                                Str.branchIdPrefText, selectedValue?['id']!);
                            Session.of.set(Str.branchIdPrefText, "${selectedValue?['id'] ?? 1}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const BottomNavigationForTaskView(
                                  selectedIndex: 0,
                                  message: '',
                                ),
                              ),
                            );
                          });
                        }
                      });
                    },
                    child: Utils.getText(
                      selectedValue?['city'] != null
                          ? selectedValue!['city'][0]
                          : 'D',
                      size: 20, // Reduced font size of the button text
                      weight: FontWeight.bold,
                      color: AppC.appColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ChatPreviewListUI(),
                          ),
                        );
                      },
                      child: Image.asset(
                        Assets.icChat,
                        width: 20,
                        height: 20,
                        fit: BoxFit.fitHeight,
                        color: AppC().base,
                      ),
                    ),*/
              BlocSelector<HeaderBloc, HeaderState, HeaderState>(
                selector: (state) => state,
                builder: (context, state) => GestureDetector(
                  onTap: () => context.push(WorkHoursViewUI(), fullscreenDialog: true),
                  child: Container(
                    decoration: Utils.getBoxDecoration(),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Utils.getText(' ${context.watch<HeaderBloc>().checkInCount}/${context.watch<HeaderBloc>().checkOutCount} '),
                  ),
                ),
              ),
              GestureDetector(
                // onTapDown: (details) => BranchPopupMenu.show(context, offset: details.globalPosition, onChanged: (value) => context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 0))),
                onTapDown: (details) => BranchPopupMenu.show(context, offset: details.globalPosition, onChanged: (value) => Console.of.warning(value)),
                /*onTap: () {
                        Utils.dismissKeyboard(context);
                        showMenu<Map<String, dynamic>>(
                          color: Colors.white,
                          context: context,
                          position: const RelativeRect.fromLTRB(10, 50, 0, 50),
                          items: branch.map((item) {
                            bool isSelected = selectedValue == item;
                            return PopupMenuItem<Map<String, dynamic>>(
                              value: item,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2), // Reduced vertical margin
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      6), // Smaller border radius
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10), // Reduced padding
                                child: Center(
                                  child: Text(
                                    item['city'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // Smaller font size
                                      color:
                                          isSelected ? Colors.white : Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedValue = value;
                              Utils.setIntPreference(
                                  Str.branchIdPrefText, selectedValue?['id']!);
                              Session.of.set(Str.branchIdPrefText, "${selectedValue?['id'] ?? 1}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const BottomNavigationForTaskView(
                                    selectedIndex: 0,
                                    message: '',
                                  ),
                                ),
                              );
                            });
                          }
                        });
                      },*/
                child: ValueListenableBuilder(valueListenable: getIt<CommonService>().updateBranch, builder: (context, value, child) => Utils.getText((Session.of.getString(Str.branchNamePrefText)?[0] ?? "D"),
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppC.appColor),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
