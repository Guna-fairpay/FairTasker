
import 'package:fairpytasker/Bloc/department_bloc.dart';
import 'package:fairpytasker/Event/department_event.dart';
import 'package:fairpytasker/State/department_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    }
  }

  Future<void> _delete(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Department?');
    if (confirmed == true) {
      final delete = departmentList[index];
      departmentBloc.add(DeleteDepartment(id: delete['id'].toString()));
      departmentBloc.add(const GetDepartmentData());
    }
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
      appBar: AppBar(
        title: const Text('Department List'),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.close)
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => departmentBloc..add(const GetDepartmentData()),
        child: BlocConsumer<DepartmentBloc, DepartmentState>(
            listener: (context, state) async {
          if (state is DepartmentLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is DepartmentListLoaded) {
                departmentList.clear();
                filterDepartmentList.clear();
                departmentList.addAll(state.data ?? []);
                filterDepartmentList = departmentList;
            } else if (state is DepartmentLoaded) {
                Utils.showMobileToast(state.message??'');
                departmentBloc.add(const GetDepartmentData());
            } else {
              departmentBloc.add(const GetDepartmentData());
            }
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, bottom: 20, top: 10),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getSearchBarUI(
                            onChange: _filterhead,
                            searchController: searchController,),
                        ),
                        Utils.getAddElevatedButton(()=>_navigateToDepartmentAddUI())
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context,index)=>const Divider(height: 0.5,),
                        itemCount: filterDepartmentList.length,
                        itemBuilder: (context, index) {
                          final head = filterDepartmentList[index];
                          return InkWell(
                            onTap: () {
                              _navigateToEditDepartmentUI(index);
                            },
                            child: SafeArea(
                              minimum: 10.padding,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: 0.padding,
                                horizontalTitleGap: 0,
                                minTileHeight: 0,
                                titleAlignment: ListTileTitleAlignment.top,
                                dense: true,
                                leading:  Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Utils.getText((index+1).toString(),color: AppC.blue),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      head['name'] ?? '',
                                      weight: FontWeight.bold,
                                    ),
                                    Utils.getText(
                                      "${head['users']?['first_name'] ?? ''} ${head['users']?['last_name'] ?? ''}",
                                      color: AppC.subText,
                                    ),
                                  ],
                                ),
                                trailing : InkWell(
                                  onTap: ()=>_delete(index),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: AppC.redAccent,
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
            ],
          );
        }),
      ),
    );
  }
}
