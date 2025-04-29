import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/import_task/bloc/import_task_bloc.dart';
import 'package:fairpytasker/UI/import_task/bloc/import_task_events.dart';
import 'package:fairpytasker/UI/import_task/bloc/import_task_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImportTaskMainUi extends StatelessWidget {
  final int? fixedPage;
  const ImportTaskMainUi({super.key, this.fixedPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text( (fixedPage != null) ? "Turo Reservation" :  "Import Task"),
          titleTextStyle:
              context.textTheme.titleMedium?.copyWith(color: AppC.white),
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          backgroundColor: AppC.appColor,
          foregroundColor: AppC.white,
          actions: [
            IconButton(
                onPressed: context.pop, icon: const Icon(Icons.close_rounded))
          ],
        ),
        body: BlocProvider(
          create: (context) => ImportTaskBloc()..add(ImportTaskInitialEvent(fixedPageIndex: fixedPage)),
          child: BlocListener<ImportTaskBloc, ImportTaskState>(
            listener: (context, state) {
              if (state is ImportTaskLoadingState) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch (state) {
                  case ImportTaskErrorState(): Toaster.showError(state.message, context: context); break;
                  case ImportTaskSuccessState(): Toaster.showSuccess("Successfully imported", context: context); break;
                  case ImportTaskCompletedState(): context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 0)); break;
                }
              }
            },
            child: BlocBuilder<ImportTaskBloc, ImportTaskState>(
              builder: (context, state) => SafeArea(
                minimum: 16.sp.padding,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: (fixedPage == null) ? BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusLarge),
                        border: Border.all(color: AppC.fieldBase)) : null,
                    padding: (fixedPage == null) ? 10.sp.padding : EdgeInsets.zero,
                    child: Form(
                      key: (context.watch<ImportTaskBloc>().currentPageIndex == 0)
                          ? context.watch<ImportTaskBloc>().textFormKey
                          : context.watch<ImportTaskBloc>().turoFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10.sp,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (fixedPage == null)
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color: AppC.borderColor,
                                        width: Num.borderWidthThinField))),
                            child: Row(
                              children: [
                                CustomTabButton(
                                  buttonText: "Text Upload",
                                  value: 0,
                                  selectedValue: context
                                      .watch<ImportTaskBloc>()
                                      .currentPageIndex,
                                  selectedBorderColor: AppC.appColor,
                                  onPressed: (val) => context
                                      .read<ImportTaskBloc>()
                                      .add(ImportTaskPageEvent(val)),
                                ),
                                CustomTabButton(
                                  buttonText: "Turo Reservation",
                                  value: 1,
                                  selectedValue: context
                                      .watch<ImportTaskBloc>()
                                      .currentPageIndex,
                                  selectedBorderColor: AppC.appColor,
                                  onPressed: (val) => context
                                      .read<ImportTaskBloc>()
                                      .add(ImportTaskPageEvent(val)),
                                ),
                                const Spacer(flex: 1)
                              ],
                            ),
                          ),
                          CompactTextField(
                            controller: (context
                                        .watch<ImportTaskBloc>()
                                        .currentPageIndex ==
                                    0)
                                ? context.watch<ImportTaskBloc>().textController
                                : context.watch<ImportTaskBloc>().turoController,
                            minLines: 10.sp.ceil(),
                            maxLines: 16.sp.ceil(),
                            borderColor: AppC.text,
                            hintText: "Paste your text here...",
                            validator: (value) =>
                                (value?.trim().isNullOrEmpty ?? false)
                                    ? "Please enter text"
                                    : null,
                          ),
                          SuccessButton(
                            text: "Submit",
                            onPressed: () => context.read<ImportTaskBloc>().add(ImportTaskSaveEvent()),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
