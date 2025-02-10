
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import '../../../../Bloc/todo_view_bloc.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigEditUI extends StatefulWidget {
  final Map<String, dynamic> config;
  const CategoryConfigEditUI({
    super.key,
    required this.config,
  });

  @override
  State<CategoryConfigEditUI> createState() => _CategoryConfigEditUIState();
}

class _CategoryConfigEditUIState extends State<CategoryConfigEditUI> {
  late TodoViewBloc todoViewBloc;
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> userType = [
    {'id':1,'name':'select'},
    {'id':2,'name':'Support Task'}];
  dynamic selectedCategory;
  dynamic selectedUserType;
  bool isFirstNameFieldEmpty = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    nameController.text = widget.config['name'] ?? '';
   
    selectedUserType = (widget.config['todo_user_type'] ?? userType[1]) == 1
        ? userType[1]
        : userType[0];
    print(widget.config);
  }

  void _save() {
    setState(() {
      isFirstNameFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updateConfig = {
      'id': widget.config['id'],
      'name': nameController.text,
      'parent_id': selectedCategory['id'],
      'todo_user_type': selectedUserType['id'] == 2 ? 1 : 0,
    };
    Navigator.of(context).pop(updateConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Edit Category Config',),
        foregroundColor:AppC.white,
        actions:  [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon:  const Icon(Icons.close,color: AppC.white,)),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            todoViewBloc..add(const GetCategoryConfigData()),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
            listener: (context, state) {
          if (state is TodoListLoading) {
            loading = true;
          } else if (state is CategoryConfigListLoaded) {
            loading = false;
            category.clear();
            final List<Map<String, dynamic>> list = [];
            list.addAll(state.data ?? []);
            category.addAll(list.where((item) => item['parent_id'] == null));
            selectedCategory = category.firstWhere(
                  (cat) => cat['id'] == widget.config['parent_id'],
              orElse: () => {},
            );
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getTextFormField(
                            '',
                            nameController,
                            label: Utils.getText('Name', color: AppC.grey),
                            borderColor: isFirstNameFieldEmpty
                                ? Colors.red
                                : AppC.fieldBase,
                          ),
                          if (isFirstNameFieldEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.error_outline,
                                  color: Colors.red),
                            ),
                        ],
                      ),
                      Utils.dropdownBox(
                          'Select Category',
                          category,
                              (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          labelKey: 'name',
                        initialSelection: selectedCategory,
                        selectedKey: selectedCategory,
                      ),
                      Utils.dropdownBox(
                          'Select',
                          userType,
                              (value) {
                            setState(() {
                              selectedUserType = value;
                            });
                          },
                          labelKey: 'name',
                        selectedKey: selectedUserType,
                        initialSelection: selectedUserType,
                      ),
                      Utils.getElevatedButton(
                              () => _save(),
                          text: 'Save',
                          bgColor: AppC.green
                      ),
                    ],
                  ),
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
