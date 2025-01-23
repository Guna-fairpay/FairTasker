import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'dart:async';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/UI/Chat/chat_preview_list_ui.dart';
import 'package:flutter/cupertino.dart';
import '../State/todo_view_state.dart';
import '../UI/TaskList_ViewUI.dart';
import '../Utilities/str.dart';
import '../main.dart';
import 'bottom_nav_for_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderView extends StatefulWidget implements PreferredSizeWidget {
  const HeaderView({
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderView> createState() => _HeaderViewState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderViewState extends State<HeaderView> {
  Duration duration = const Duration();
  Timer? timer;
  String? userRole;
  bool statusFilter = false;
  Map<String, dynamic>? selectedValue;
  List<Map<String, dynamic>> branch = [];
  late TodoViewBloc todoViewBloc;
  int? branchNO;

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    todoViewBloc.add(const GetBranchList());
    _loadUserRole();
    _loadBranchId();
  }

  Future<void> _loadUserRole() async {
    final role = await Utils.getStringListPreference(Str.rolePrefText);
    if (role.isNotEmpty) {
      setState(() {
        userRole = role[0];
      });
    }
  }

  Future<void> _loadBranchId() async {
    final branchId = await Utils.getIntPreference(Str.branchIdPrefText);
    setState(() {
      branchNO = branchId;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (selectedValue == null && branch.isNotEmpty) {
      // Safely set the initial value outside of the build process
      selectedValue = branch.firstWhere(
        (item) => item['id'] == '1',
        orElse: () => branch.isNotEmpty ? branch[0] : {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => todoViewBloc,
      child: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppC.white,
        leadingWidth: 0,
        titleSpacing: 0,
        leading: const Padding(
          padding: EdgeInsets.only(bottom: 8.0, left: 12),
          child: Icon(Icons.sort_outlined, color: AppC.trans),
        ),
        title: BlocBuilder<TodoViewBloc, TodoViewState>(
          builder: (context, state) {
            if (state is BranchListLoaded) {
              branch.clear();
              branch.addAll(state.data ?? []);
              if (selectedValue == null && branch.isNotEmpty) {
                // Only update selectedValue if it's not set
                selectedValue = branch.firstWhere(
                  (item) => item['id'] == branchNO,
                  orElse: () => branch[0],
                );
              }
            }

            return Padding(
              padding:
                  const EdgeInsets.only(left: 5, top: 0, bottom: 5, right: 18),
              child: Row(
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(
                          Icons.sort_outlined,
                          color: AppC().base,
                          size: 28,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      );
                    },
                  ),
                  GestureDetector(
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
                      width: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Spacer(),
                  if (userRole == 'Admin')
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TaskListViewUI()));
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
                          : 'S',
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
      ),
    );
  }
}
