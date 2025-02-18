import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/users_bloc.dart';
import '../../../../Event/users_event.dart';
import '../../../../State/user_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'user_add_ui.dart';
import 'user_edit_ui.dart';

class UserViewUI extends StatefulWidget {
  const UserViewUI({super.key});

  @override
  State<UserViewUI> createState() => _UserViewUIState();
}

class _UserViewUIState extends State<UserViewUI> {
  late UsersBloc userBloc = UsersBloc();
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filterUsers = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  void _filterUsers(String query) {
    setState(() {
      filterUsers = users.where((user) {
        final userFirstName = user['first_name']?.toLowerCase() ?? '';
        final userLastName = user['last_name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return userFirstName.contains(searchQuery)
        ||userLastName.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToUserAddUI() async {
    final newUser = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const UserAddUI()),
    );
    if (newUser != null) {
      userBloc.add(AddUsersData(
          user: newUser['user'],
          permissions: newUser['permissions']));
      userBloc.add(const GetUsersData());
    }
  }

  void _navigateToEditUserUI(int index) async {
    final updatedUser = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => UserEditUI(
          users: filterUsers[index],
        ),
      ),
    );
    if (updatedUser != null) {
      userBloc.add(AddUsersData(
        user: updatedUser['user'],
        permissions: updatedUser['permissions'],
      ));
      userBloc.add(const GetUsersData());
    }
  }

  Future<void> _deleteUser(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'User?');
    if (confirmed == true) {
      setState(() {
        users.removeAt(index);
        _filterUsers(searchController.text);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => userBloc..add(const GetUsersData()),
        child: BlocConsumer<UsersBloc, UsersState>(
            listener: (context, state) {
          if (state is UsersLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is UsersListLoaded) {
              users.clear();
              users.addAll(state.data ?? []);
              filterUsers = List.from(users);
            } else if(state is UsersLoaded){
              Utils.showMobileToast(state.message);
              userBloc.add(const GetUsersData());
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(onChange: _filterUsers, searchController: searchController),
                    ),
                    Utils.getAddElevatedButton(()=>_navigateToUserAddUI()),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(height: 0.5,),
                    itemCount: filterUsers.length,
                    itemBuilder: (context, index) {
                      final user = filterUsers[index];
                      return InkWell(
                        onTap: () => _navigateToEditUserUI(index),
                        child: SafeArea(
                          minimum: 10.padding,
                          child: Row(
                            children: [
                              Expanded(
                                child: Utils.getText(
                                  '${user['first_name']} ${user['last_name']}',
                                ),
                              ),
                              InkWell(
                                onTap: () => _deleteUser(index),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: AppC.redAccent,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
