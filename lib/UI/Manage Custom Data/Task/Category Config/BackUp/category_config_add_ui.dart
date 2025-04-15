
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../Bloc/todo_view_bloc.dart';
import '../../../../../Event/todo_view_event.dart';
import '../../../../../State/todo_view_state.dart';
import '../../../../../Utilities/appC.dart';
import '../../../../../Utilities/utils.dart';

class CategoryConfigAddUI extends StatefulWidget {
  final List<Map<String, dynamic>>? category;
  const CategoryConfigAddUI({super.key,required this.category});

  @override
  State<CategoryConfigAddUI> createState() => _CategoryConfigAddUIState();
}

class _CategoryConfigAddUIState extends State<CategoryConfigAddUI> {
  late TodoViewBloc todoViewBloc;
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> userType = [
    {'id':1,'name':'select'},
    {'id':2,'name':'Support Task'}
  ];
  dynamic selectedCategory;
  dynamic selectedUserType;
  bool isFirstNameFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    category.addAll(
      widget.category!.where(
              (item) => item['parent_id'] == null),
    );
    selectedUserType = userType[0];
  }

  void _save() {
    setState(() {
      isFirstNameFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final newConfig = {
      'name': nameController.text,
      'parent_id': selectedCategory?['id'] ?? null,
      'todo_user_type': selectedUserType?['id'] == 2 ? 1 : 0,
    };
   Navigator.of(context).pop(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Add Category Config',),
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
                EasyLoading.show();
              } else{
                if(EasyLoading.isShow)EasyLoading.dismiss();
                if (state is CategoryConfigListLoaded) {
                  category.clear();
                  final List<Map<String, dynamic>> list = [];
                  list.addAll(state.data ?? []);
                  category.addAll(list.where((item) => item['parent_id'] == null));
                }
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
                            'Name',
                            nameController,
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
            ],
          );
        }),
      ),
    );
  }
}
