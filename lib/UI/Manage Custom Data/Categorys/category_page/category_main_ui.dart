import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/category_alter_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/category_listing_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryMainUi extends StatelessWidget {
  const CategoryMainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        titleTextStyle:
            context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocProvider(
        create: (context) => CategoryBloc()..add(CategoryInitialEvent()),
        child: BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              if (state is CategoryDeleteTapState) {
                AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this Category?", onPositivePressed: () => context.read<CategoryBloc>().add(CategoryDeleteEvent(state.model)));
              }
            }
          },
          child: SafeArea(
              minimum: 16.sp.padding,
              child: ListView(
                children: [
                  const CategoryAlterUi(),
                  10.height,
                  const CategoryListingUi(),
                ],
              )),
        ),
      ),
    );
  }
}
