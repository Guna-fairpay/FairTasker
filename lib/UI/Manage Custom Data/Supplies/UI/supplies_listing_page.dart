
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utilities/utils.dart';

class SuppliesListingPage extends StatelessWidget {
  const SuppliesListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliesBloc, SuppliesState>(
        builder: (context, state) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    topRight: Radius.circular(5.r),
                  )),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Utils.getText('Name', weight: FontWeight.bold)),
                  Utils.getText('Action', weight: FontWeight.bold),
                ],
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  height: 0.5,
                ),
                itemCount: context.watch<SuppliesBloc>().filteredResponse.length,
                itemBuilder: (context, index) {
                  var item = context.watch<SuppliesBloc>().filteredResponse[index];
                  return SafeArea(
                    minimum: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                    child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Utils.getText(item['name'] ?? '',
                                size: 12.sp, overFlow: TextOverflow.visible),
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              InkWell(
                                  onTap: () => context.read<SuppliesBloc>().add(EditSuppliesEvent(data: item)),
                                  child: Icon(Icons.edit_outlined,color: AppC.blue,size: 20.sp,)),
                              InkWell(
                                  onTap: () {
                                    AskPermissionDialog.show(context,
                                        title: "Are you sure?",
                                        description:
                                        "Do you want to delete this Part?",
                                        positiveText: "Yes, delete it!",
                                        negativeText: "Cancel",
                                        isReasonRequired: false,
                                        onPositivePressed: ()=>context.read<SuppliesBloc>().add(DeleteSuppliesEvent(data: item))
                                    );
                                  },
                                  child: Icon(Icons.delete_outline,color: AppC.redAccent,size: 20.sp,)),
                            ],
                          )
                        ]),
                  );
                }),
            CompactPagination(
              currentPage: context.watch<SuppliesBloc>().currentIndex,
              totalPages: (context.watch<SuppliesBloc>().totalCount /
                  context.watch<SuppliesBloc>().itemsPerPage)
                  .ceil(),
              onPageChanged: (value) => context
                  .read<SuppliesBloc>()
                  .add(SuppliesPaginationEvent(page: value)),
            ),
          ],
        ));
  }
}
