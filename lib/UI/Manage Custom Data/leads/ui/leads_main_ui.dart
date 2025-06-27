
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/bloc/leads_bloc.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'leads_text_form_field_first_part.dart';

class LeadsMainUI extends StatelessWidget {
  const LeadsMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: 'Leads',
        onClose: context.pop,
      ),
      body: BlocProvider(
        create: (context) => LeadsBloc()..add(InitialEvent()),
          child: BlocListener<LeadsBloc, LeadsState>(
            listener: (context, state) {
              if(state is LoadingState){
                EasyLoading.show();
              }else{
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.message);
                  case SuccessState(): Toaster.showSuccess(state.message);
                }
              }
            },
              child: SafeArea(
                minimum: 15.spMin.padding,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                    children: const [
                      LeadsTextFormFieldFirstPart(),
                    ] ),
              ))),
    );
  }
}
