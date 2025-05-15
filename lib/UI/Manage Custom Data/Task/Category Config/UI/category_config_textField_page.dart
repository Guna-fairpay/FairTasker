
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/UI/category_config_list_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryConfigTextFieldPage extends StatelessWidget {
  const CategoryConfigTextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryConfigBloc, CategoryConfigState>(
        builder: (context,state){
          return Form(
            key: context.read<CategoryConfigBloc>().formKey,
            child: Column(
              spacing: 10,
              children: [
                Utils.getTextFormField('Name', context.read<CategoryConfigBloc>().nameController,
                  autoValidate: context.watch<CategoryConfigBloc>().autoValidateMode,
                  validator: (val) => val!.isEmpty ? 'Please enter task name' : null ,
                ),
                Utils.dropdownBox('Select Category',
                    context.read<CategoryConfigBloc>().category,
                        (v){
                  context.read<CategoryConfigBloc>().add(CategoryDropDownEvent(data: v));
                  Utils.dismissKeyboard(context);
                  },
                    labelKey: 'name',
                  initialSelection: context.read<CategoryConfigBloc>().selectedCategory,
                  selectedKey: context.read<CategoryConfigBloc>().selectedCategory,
                ),
                Utils.dropdownBox('Select', context.read<CategoryConfigBloc>().usersType,
                        (v){
                  context.read<CategoryConfigBloc>().add(UserTypeDropDownEvent(data: v));
                  Utils.dismissKeyboard(context);
                  },
                    labelKey: 'name',
                  initialSelection: context.read<CategoryConfigBloc>().selectedUserType,
                  selectedKey: context.read<CategoryConfigBloc>().selectedUserType,
                ),
                Row(
                  //spacing: 10,
                  children: [
                    if(!context.read<CategoryConfigBloc>().isEdit)
                      SuccessButton(text: 'Save',onPressed:() => context.read<CategoryConfigBloc>().add(SaveCategoryConfigEvent())),
                    if(context.read<CategoryConfigBloc>().isEdit)
                      ...[CompactIconButton(icon:Icons.save_outlined,backgroundColor: AppC.green,onPressed: ()=>context.read<CategoryConfigBloc>().add(SaveCategoryConfigEvent()),),
                        CompactIconButton(icon:Icons.close_outlined,backgroundColor: AppC.redAccent,onPressed: ()=>context.read<CategoryConfigBloc>().add(EditCloseEvent()),),],
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 8,
                        child: CompactSearchView(
                          controller: context.read<CategoryConfigBloc>().searchController,
                          onChanged: (value) => context.read<CategoryConfigBloc>().add(SearchCategoryConfigEvent(value)),
                        ))
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        topRight: Radius.circular(5.r),
                      )),
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Utils.getText('Name', weight: FontWeight.bold)),
                      Expanded(child: Utils.getText('Category', weight: FontWeight.bold)),
                      Utils.getText('Action', weight: FontWeight.bold),
                    ],
                  ),
                ),
                const CategoryConfigListPage(),
              ],
            ),
          );
        });
  }
}
