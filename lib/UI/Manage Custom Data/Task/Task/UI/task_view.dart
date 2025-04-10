
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/dropdownBoxWithIcon.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_listing_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
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
          child: Column(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              10.sp.height,
              Utils.getTextFormField(
                  'Task',
                  context.read<TaskBloc>().taskController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter task name' : null,
              ),
              10.sp.height,
              DropdownBoxWithIcon(
                hindText: 'Select Category',
                list: [],
                onTap: () =>context.push(const CategoryViewUi()),
                onChanged: (v){},
                label: '',
                initialSelection: {},
              ),
              10.sp.height,
              DropdownBoxWithIcon(
                list: [],
                hindText: 'Select SubCategory',
                onTap: () =>context.push(const CategoryViewUi()),
                onChanged: (v){},
                label: '',
                initialSelection: {},
              ),
              10.sp.height,
              Utils.getTextFormField(
                'Time taken to complete in minutes (eg: 30)',
                context.read<TaskBloc>().timeTakenController,
              ),
              10.sp.height,
              Utils.dropdownBox(
                'select user type',
                [], (value){},
                labelKey: 'name',
                initialSelection: {},
              ),
              10.sp.height,
              Row(
                //spacing: 10,
                children: [
                  SuccessButton(text: 'Save',),
                  Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      activeColor: AppC.redAccent,
                      checkColor: AppC.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                      value: true,
                      onChanged: (value){}),
                  Utils.getText('No Category',weight: FontWeight.bold),
                  Expanded(
                    child: Utils.getSearchBarUI(
                      onChange:
                          (value) {
                    
                      },
                      searchController:context.read<TaskBloc>().searchController,
                    ),
                  ),

                  /*IconButton.filled(
                    onPressed: (){},
                    icon: Icon(Icons.close,color: AppC.white,),
                    style: ButtonStyle(shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(Num.borderRadius),
                  ),)),),
                  10.sp.width,
                  IconButton.filled(
                    onPressed: (){},
                    icon: Icon(Icons.close,color: AppC.white,),
                    style: ButtonStyle(shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(Num.borderRadius),
                    ),)),)*/

                ],
              ),
              //TaskListingPage(),
            ],
          ),
        );
      },
    );
  }
}
