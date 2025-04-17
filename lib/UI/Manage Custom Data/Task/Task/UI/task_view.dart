
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/category_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/dropdownBoxWithIcon.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_listing_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Form(
          key: context.read<TaskBloc>().formKey,
          // autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            children: [
              10.sp.height,
              Utils.getTextFormField(
                  'Task',
                  context.read<TaskBloc>().taskController,
                autoValidate: context.watch<TaskBloc>().autoValidateMode,
                validator: (val) => val!.isEmpty ? 'Please enter task name' : null ,
              ),
              10.sp.height,
              DropdownBoxWithIcon(
                hindText: 'Select Category',
                list: context.read<TaskBloc>().category,
                onTap: () =>context.push(const CategoryMainUi()),
                onChanged: (v)=>context.read<TaskBloc>().add(CategoryDropDownEvent(data: v)),
                label: 'name',
                initialSelection: context.read<TaskBloc>().selectedCategory,
                selectedKey: context.read<TaskBloc>().selectedCategory,
              ),
              10.sp.height,
              DropdownBoxWithIcon(
                list: context.read<TaskBloc>().subcategory,
                hindText: 'Select SubCategory',
                onTap: () =>context.push(const SubcategoryMainUi()),
                onChanged: (v)=>context.read<TaskBloc>().add(SubcategoryDropDownEvent(data: v)),
                label: 'name',
                initialSelection: context.read<TaskBloc>().selectedSubCategory,
                selectedKey: context.read<TaskBloc>().selectedSubCategory,
              ),
              10.sp.height,
              Utils.getTextFormField(
                'Time taken to complete in minutes (eg: 30)',
                context.read<TaskBloc>().timeTakenController,
                textType: TextInputType.number,
                textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}'))],
              ),
              10.sp.height,
              Utils.dropdownBox(
                'select user type',
                context.read<TaskBloc>().usersType,
                    (value)=>context.read<TaskBloc>().add(UserTypeDropDownEvent(data: value)),
                labelKey: 'name',
                initialSelection: context.read<TaskBloc>().selectedUserType,
              ),
              10.sp.height,
              Row(
                //spacing: 10,
                children: [
                  if(!context.read<TaskBloc>().isEdit)
                  SuccessButton(text: 'Save',onPressed:() => context.read<TaskBloc>().add(SaveTaskEvent())),
                  if(context.read<TaskBloc>().isEdit)
                    ...[CompactIconButton(icon:Icons.save_outlined,backgroundColor: AppC.green,onPressed: ()=>context.read<TaskBloc>().add(SaveTaskEvent()),),
                      CompactIconButton(icon:Icons.close_outlined,backgroundColor: AppC.redAccent,onPressed: ()=>context.read<TaskBloc>().add(EditCloseState()),),],
                  Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      activeColor: AppC.redAccent,
                      checkColor: AppC.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: context.read<TaskBloc>().noCategory,
                      onChanged: (value)=>context.read<TaskBloc>().add(NoCategoryEvent(value: value))),
                  Utils.getText('No Category',weight: FontWeight.bold),
                  10.sp.width,
                  Expanded(
                      child: CompactSearchView(
                    controller: context.read<TaskBloc>().searchController,
                    onChanged: (value) => context.read<TaskBloc>().add(SearchTaskEvent(value)),
                  ))
                ],
              ),
              const TaskListingPage(),
            ],
          ),
        );
      },
    );
  }
}
