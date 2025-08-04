
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/UI/category_config_textField_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryConfigMainPage extends StatelessWidget {
  const CategoryConfigMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryConfigBloc>(
      create: (context)=>CategoryConfigBloc()..add(CategoryConfigInitialEvent()),
      child: BlocListener<CategoryConfigBloc, CategoryConfigState>(
        listener: (context, state) {
          if (state is CategoryConfigLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
          if (state is CategoryConfigCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
        },
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 10.spMin),
          child: const CategoryConfigTextFieldPage()
        ),
      ),
    );
  }
}
