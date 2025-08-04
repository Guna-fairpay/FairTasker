
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utilities/utils.dart';

class PartsListingPage extends StatelessWidget {
  const PartsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartsBloc, PartsState>(
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
                  Expanded(child: Utils.getText('Parts Name', weight: FontWeight.bold, size: 14.spMin)),
                  Utils.getText('Action', weight: FontWeight.bold, size: 14.spMin),
                ],
              ),
            ),
            context.watch<PartsBloc>().filteredResponse.isEmpty
                ? Utils.getText('No data found ', weight: FontWeight.bold)
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(
                height: 0.5,
              ),
              itemCount: context.watch<PartsBloc>().filteredResponse.length,
              itemBuilder: (context, index) {
                var item = context.watch<PartsBloc>().filteredResponse[index];
                return SafeArea(
                  minimum: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                  child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<PartsBloc>().add(EditPartsEvent(data: item)),
                            child: Utils.getText(item['name'] ?? '',
                                size: 12.spMin, overFlow: TextOverflow.visible),
                          ),
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            InkWell(
                                onTap: () => context.read<PartsBloc>().add(EditPartsEvent(data: item)),
                                child: Icon(Icons.edit_outlined,color: AppC.blue,size: 20.spMin,)),
                            InkWell(
                                onTap: () {
                                  AskPermissionDialog.show(context,
                                      title: "Are you sure?",
                                      description:
                                      "Do you want to delete this Part?",
                                      positiveText: "Yes, delete it!",
                                      negativeText: "Cancel",
                                      isReasonRequired: false,
                                      onPositivePressed: ()=>context.read<PartsBloc>().add(DeletePartsEvent(data: item))
                                  );
                                },
                                child: Icon(Icons.delete_outline,color: AppC.redAccent,size: 20.spMin,)),
                          ],
                        )
                      ]),
                );
              }),
            CompactPagination(
              currentPage: context.watch<PartsBloc>().currentIndex,
              totalPages: (context.watch<PartsBloc>().totalCount /
                  context.watch<PartsBloc>().itemsPerPage)
                  .ceil(),
              onPageChanged: (value) => context
                  .read<PartsBloc>()
                  .add(PartsPaginationEvent(page: value)),
            ),
          ],
        ));
  }
}
