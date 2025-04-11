
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/dropdownBoxWithIcon.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/popup_with_icons.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskListingPage extends StatelessWidget {
  const TaskListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
         separatorBuilder: (context, index) => const Divider(height: 0.5,),
          itemCount: 10,
          itemBuilder: (context, index) => Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.getText('Task Name',size: 12.sp),
              Flexible(child: Utils.dropdownBox('select user type', [], (v){}, labelKey: '')),
              Flexible(child: Utils.dropdownBox('select user type', [], (v){}, labelKey: '')),
             ///CompactIconButton()
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  PopupWithIcons.show(
                    context,
                    details,() {},() =>{}
                  );
                },
                child: Icon(Icons.more_horiz,color: AppC.appColor,size: 14.sp,),
              ),
              ///(child: Icon(Icons.more_horiz,color: AppC.redAccent,size: 18,))
            ]
          )
        );
      },
    );
  }
}
