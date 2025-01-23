import 'package:fairpytasker/Bloc/department_bloc.dart';
import 'package:fairpytasker/Event/department_event.dart';
import 'package:fairpytasker/State/department_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/str.dart';
import '../../../Utilities/utils.dart';
import 'department_addUI.dart';
import 'department_edit_ui.dart';

class DepartmentViewUI extends StatefulWidget {
  const DepartmentViewUI({super.key});

  @override
  State<DepartmentViewUI> createState() => _DepartmentViewUIState();
}

class _DepartmentViewUIState extends State<DepartmentViewUI> {
  late DepartmentBloc departmentBloc;
  List<Map<String, dynamic>> departmentList = [];
  List<Map<String, dynamic>> filterDepartmentList = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, String>> heads = []; // Sample data list
  List<Map<String, String>> addedHead = [];
  bool loading = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    departmentBloc = DepartmentBloc();
    Utils.getStringListPreference(Str.rolePrefText).then((role) {
      setState(() {
        userRole = role.first;
      });
    });
  }

  void _filterhead(String query) {
    setState(() {
      filterDepartmentList = departmentList.where((heads) {
        final departmentName = heads['name']?.toLowerCase() ?? '';
        final headName = heads['head']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return departmentName.contains(searchQuery) ||
            headName.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToDepartmentAddUI() async {
    final newDepartment = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const DepartmentAddUI()),
    );
    if (newDepartment != null) {
      departmentBloc.add(AddDepartmentData(
        name: newDepartment['name'],
        head: newDepartment['head'],
        id: newDepartment['id'],
      ));
      departmentBloc.add(const GetDepartmentData());
      Utils.showMobileToast('Department Added Successfully');
    }
  }

  void _navigateToEditDepartmentUI(int index) async {
    final updateDepartment = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentEditUI(
          heads: filterDepartmentList[index], // Update filtered list
        ),
      ),
    );

    if (updateDepartment != null) {
      departmentBloc.add(AddDepartmentData(
        id: updateDepartment['id'],
        name: updateDepartment['name'],
        head: updateDepartment['head'],
      ));
      departmentBloc.add(const GetDepartmentData());
      Utils.showMobileToast('Department Updated Successfully');
    }
  }

  Future<void> _delete(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final delete = departmentList[index];
      departmentBloc.add(DeleteDepartment(id: delete['id'].toString()));
      departmentBloc.add(const GetDepartmentData());
      Utils.showMobileToast('Department Deleted Successfully');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this supply?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => departmentBloc..add(const GetDepartmentData()),
        child: BlocConsumer<DepartmentBloc, DepartmentState>(
            listener: (context, state) async {
          if (state is DepartmentLoading) {
            loading = true;
          } else if (state is DepartmentListLoaded) {
            setState(() {
              loading = false;
              departmentList.clear();
              filterDepartmentList.addAll(state.data ?? []);
              departmentList.addAll(state.data ?? []);
              filterDepartmentList = List.from(departmentList);
            });
          } else if (state is DepartmentLoaded) {
            setState(() {
              loading = false;
              departmentList.clear();
              departmentBloc.add(const GetDepartmentData());
            });
          } else {
            departmentBloc.add(const GetDepartmentData());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, bottom: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.getText('Department List',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(() {
                              // onTap action for search bar if needed
                            }, (value) {
                              _filterhead(value);
                            }, searchController,),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToDepartmentAddUI();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterDepartmentList.length,
                        itemBuilder: (context, index) {
                          final head = filterDepartmentList[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                if (userRole == 'Admin')
                                  SlidableAction(
                                    onPressed: (context) => _delete(index),
                                    backgroundColor: AppC.white,
                                    foregroundColor: AppC.red,
                                    icon: Icons.delete_outline,
                                    label: 'Delete',
                                  ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToEditDepartmentUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // height: 40,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.getText(
                                        head['name'] ?? '',
                                        weight: FontWeight.bold,
                                      ),
                                      Utils.getText(
                                        (head['users'] != null
                                            ? (head['users']['first_name'] ??
                                                    '') +
                                                ' ' +
                                                (head['users']['last_name'] ??
                                                    '')
                                            : ''),
                                        color: AppC.subText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: loading,
                  child: Center(child: Utils.getProgressIndicator(context)))
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
