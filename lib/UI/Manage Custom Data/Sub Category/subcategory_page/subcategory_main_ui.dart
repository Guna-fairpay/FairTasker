import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_body_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SubcategoryMainUi extends StatelessWidget {
  const SubcategoryMainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategory'),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocProvider(
        create: (context) => SubCategoryBloc()..add(SubCategoryInitialEvent()),
        child: BlocListener<SubCategoryBloc, SubCategoryState>(
          listener: (context, state) {
            if (state is SubCategoryLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              if (state is SubCategoryShowDeleteDialogState) {
                Utils.dismissKeyboard(context);
                AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this Category?", onPositivePressed: () => context.read<SubCategoryBloc>().add(SubCategoryDeleteEvent(state.model)));
              } else if (state is SubCategoryErrorState) {
                Toaster.showError(state.message);
              }
            }
          },
          child: const SubcategoryBodyUi(),
        ),
      ),
    );
  }
}
