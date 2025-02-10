
import 'package:flutter/material.dart';
import '../../../../Bloc/todo_view_bloc.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

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
      'parent_id': selectedCategory['id'],
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
        title: Utils.getText(
            'Add Category Config',
            weight: FontWeight.bold,
            size: 18,
            color: AppC.white
        ),
        actions:  [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon:  const Icon(Icons.close,color: AppC.white,)),
        ],
      ),
      body:  Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        print(selectedCategory['id']);
                      });
                      },
                        labelKey: 'name'),
                    Utils.dropdownBox(
                        'Select',
                        userType,
                            (value) {
                          setState(() {
                            selectedUserType = value;
                            print(selectedUserType);

                          });
                        },
                        labelKey: 'name',

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
      ),
    );
  }
}
