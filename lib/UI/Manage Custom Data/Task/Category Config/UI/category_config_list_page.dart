import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utilities/utils.dart';

class CategoryConfigListPage extends StatelessWidget {
  const CategoryConfigListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryConfigBloc, CategoryConfigState>(
      builder: (context, state) => Column(
        children: [
          context.watch<CategoryConfigBloc>().filteredResponse.isEmpty
              ? Utils.getText('No data found ', weight: FontWeight.bold)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(
                        height: 0.5,
                      ),
                  itemCount: context
                      .watch<CategoryConfigBloc>()
                      .filteredResponse
                      .length,
                  itemBuilder: (context, index) {
                    var item = context
                        .watch<CategoryConfigBloc>()
                        .filteredResponse[index];
                    return SafeArea(
                      minimum:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                      child: Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Utils.getText(item['name'] ?? '',
                                  size: 12.sp, overFlow: TextOverflow.visible),
                            ),
                            Expanded(
                                child: Utils.getText(
                              item['category_name'] ?? '',
                            )),
                            Row(
                              spacing: 5,
                              children: [
                                InkWell(
                                    onTap: () => context
                                        .read<CategoryConfigBloc>()
                                        .add(EditCategoryConfigEvent(
                                            data: item)),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: AppC.blue,
                                      size: 20.sp,
                                    )),
                                InkWell(
                                    onTap: () {
                                      AskPermissionDialog.show(context,
                                          title: "Are you sure?",
                                          description:
                                              "Do you want to delete this identifier?",
                                          positiveText: "Yes, delete it!",
                                          negativeText: "Cancel",
                                          isReasonRequired: false,
                                          onPositivePressed:
                                              () {} /*context.read<CategoryConfigBloc>().add(DeleteCategoryConfigEvent(data: item)*/);
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: AppC.redAccent,
                                      size: 20.sp,
                                    )),
                              ],
                            )
                          ]),
                    );
                  }),
          CompactPagination(
            currentPage: context.watch<CategoryConfigBloc>().currentIndex,
            totalPages: (context.watch<CategoryConfigBloc>().totalCount /
                    context.watch<CategoryConfigBloc>().itemsPerPage)
                .ceil(),
            onPageChanged: (value) => context
                .read<CategoryConfigBloc>()
                .add(CategoryConfigPaginationEvent(page: value)),
          ),
        ],
      ),
    );
  }
}
