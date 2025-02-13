import 'package:flutter/material.dart';
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
  late UsersBloc userBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filterUsers = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    userBloc = UsersBloc();
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
    final newUser = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const UserAddUI()),
    );

    // if (newUser != null) {
    //   setState(() {
    //     users.add(newUser);
    //     _filterUsers(searchController.text); // Update filtered list
    //   });
    // }
  }

  void _navigateToEditUserUI(int index) async {
    final updatedheads = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => UserEditUI(
          users: filterUsers[index],
        ),
      ),
    );

    if (updatedheads != null) {
      setState(() {
        users[index] = updatedheads;
        filterUsers = users; // Update filtered list
      });
    }
  }

  Future<void> _deleteUser(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      setState(() {
        users.removeAt(index);
        _filterUsers(searchController.text); // Update filtered list
      });
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Replace with AppC.white if defined
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Delete User',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Replace with AppC.primaryColor if defined
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to delete this user? This action cannot be undone.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel the deletion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey, // Replace with AppC.lightGray if defined
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors
                          .black87), // Replace with AppC.darkGray if defined
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm the deletion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Replace with AppC.red if defined
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => userBloc..add(const GetUsersData()),
        child: BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
          if (state is UsersLoading) {
            loading = true;
          } else if (state is UsersListLoaded) {
            loading = false;
            users.clear();
            filterUsers.addAll(state.data ?? []);
            users.addAll(state.data ?? []);
            filterUsers = List.from(users);
          } else {
            userBloc.add(const GetUsersData());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(onChange: _filterUsers, searchController: searchController),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToUserAddUI();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterUsers.length,
                        itemBuilder: (context, index) {
                          final user = filterUsers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => _deleteUser(index),
                                    backgroundColor: AppC.white,
                                    foregroundColor: AppC.red,
                                    icon: Icons.delete_outline,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {

                                  _navigateToEditUserUI(index);
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: AppC.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Utils.getText(
                                            '${user['first_name']} ${user['last_name']}',
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
    );
  }
}
