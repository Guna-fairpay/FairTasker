 import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/approve_task/bloc/approve_task_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'approve_task_listing_ui.dart';

class ApproveTaskMainUI extends StatelessWidget {
   const ApproveTaskMainUI({super.key});

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: CompactAppBar(
         titleWidget: Utils.getText('Approve Task', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
         foregroundColour: AppC.white,
         onClose: ()=> context.pop(),
       ),
       body: BlocProvider(create: (context) => ApproveTaskBloc()..add(InitialEvent()),
         child: BlocListener<ApproveTaskBloc, ApproveTaskState>(
           listener: (context, state) {
             if(State is LoadingState){
              if(!EasyLoading.isShow) EasyLoading.show();
             }else{
               if(EasyLoading.isShow) EasyLoading.dismiss();
               switch(state){
                 case ErrorState(): Toaster.showError(state.message); break;
                 case SuccessState(): Toaster.showSuccess(state.message); break;
               }
             }
             },
           child: const ApproveTaskListingUI(),
         ),
       ),
     );
   }
 }
