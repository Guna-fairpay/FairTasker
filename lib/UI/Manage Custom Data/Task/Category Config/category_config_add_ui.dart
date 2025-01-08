import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import '../../../../Bloc/category_config_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Event/category_config_event.dart';
import '../../../../State/category_config_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigAddUI extends StatefulWidget {
  const CategoryConfigAddUI({super.key});

  @override
  State<CategoryConfigAddUI> createState() => _CategoryConfigAddUIState();
}

class _CategoryConfigAddUIState extends State<CategoryConfigAddUI> {
  late CategoryConfigBloc categoryConfigBloc;
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> category = [];
  String? selectedCategory;
  List<String> userType = ['select', 'Support Task'];
  String? selectedUserType;
  String? selectedTask;
  bool isFirstNameFieldEmpty = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    categoryConfigBloc = CategoryConfigBloc();
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
      'parent_id': selectedCategory ?? '',
      'todo_user_type': selectedUserType == 'Support Task' ? 1 : 0,
    };
    Navigator.of(context).pop(newConfig);
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
        create: (context) =>
            categoryConfigBloc..add(const GetCategoryConfigData()),
        child: BlocConsumer<CategoryConfigBloc, CategoryConfigState>(
            listener: (context, state) {
          if (state is TodoListLoading) {
            loading = true;
          } else if (state is CategoryConfigListLoaded) {
            loading = false;
            category.clear();
            category.addAll(state.data ?? []);
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                          const SizedBox(
                            width: 10,
                          ),
                          Utils.getText('Add Category Config ',
                              size: 20, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Num.subradiusButton)),
                        ),
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.getText('Select Category',
                                color: AppC.grey),
                          ),
                          value: selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 3,
                          dropdownColor: AppC.white,
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          items: category
                              .where((item) =>
                                  item['parent_id'] ==
                                  null) // Filter where parent_id is null
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['id'].toString(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Utils.getText('${value['name']}'),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton)),
                          ),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('select', color: AppC.grey),
                            ),
                            value: selectedUserType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 3,
                            dropdownColor: AppC.white,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedUserType = value;
                              });
                            },
                            items: userType
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Utils.getText(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Save', () {
                              _save();
                            }),
                          ),
                        ],
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
      drawer: const DrawerView(),
    );
  }
}
