
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../feedback_edit/bloc/fb_edit_bloc.dart';
import '../feedback_edit/bloc/fb_edit_events.dart';
import '../feedback_edit/bloc/fb_edit_states.dart';
import '../feedback_edit/feedback_comment_attachments.dart';

class FeedbackCommentsView extends StatelessWidget {

  const FeedbackCommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
        buildWhen: (previous, current) =>
        current is FBFeedbackState || current is FBCommentState,
        builder: (context, state) => (state is FBCommentState)
        ?
      Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                10.height,
                Utils.getTextFormField(
                    null,
                    context.read<FBEditBloc>().commentController,
                    hintText:'Add your comment',
                    inputAction: TextInputAction.done,
                  /*inputAction: TextInputAction.newline,
                  textType: TextInputType.multiline,*/
                  maxLines: 3,
                  minLines: 2
                ),
                10.height,
                CompactFilePicker(
                  controller:context.read<FBEditBloc>().filePickerController,
                  onPressed:()=> context.read<FBEditBloc>().add(FBCommentAddAttachmentEvent()),
                ),
                10.height,
                const FeedbackCommentAttachments(),
                10.height,
                if(context.read<FBEditBloc>().isEdit == false)...[
                  Row(
                    children: [
                      SuccessButton(
                        text: "Add",
                        backgroundColor: AppC.appColor,
                        onPressed: () => context.read<FBEditBloc>().add(FBCommentSubmitEvent()),
                      ),
                    ],
                  ),
                ] else...[
                  Row(
                    spacing: 10,
                    children: [
                      SuccessButton(
                        text: "Update",
                        backgroundColor: AppC.appColor,
                        onPressed: ()=>
                            context.read<FBEditBloc>().add(FBUpdateCommentEvent(
                                context.read<FBEditBloc>().commentId,
                                context.read<FBEditBloc>().commentController.text
                            )
                            ),
                      ),
                      SuccessButton(
                        text: "Cancel",
                        backgroundColor: AppC.red,onPressed: ()=>
                          context.read<FBEditBloc>().add(FBCommentsEditCancelEvent()),
                      )
                    ],
                  )
                ],
                10.height,
                Utils.getText("Comments",weight: FontWeight.bold,size: 12.sp),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 0.5,height: 0,indent: 50,),
                  itemCount: state.comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                    var list = state.comments;
                    list.sort((a, b) => b['updated_at'].compareTo(a['updated_at']));
                      var model = list[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => context.read<FBEditBloc>().add(FBCommentDeleteEvent(model['id'])),
                              backgroundColor: Colors.white,
                              foregroundColor: AppC.red,
                              icon: Icons.delete_outline,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                          ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              minVerticalPadding: 0,
                              leading: CircleAvatar(
                                radius: 15.sp,
                                child: Center(
                                    child: Utils.getText(<String>[(model?['users']?['first_name'] ?? ''), (model?['users']?['last_name'] ?? '')].toInitial,
                                        size: 13.sp,
                                        weight: FontWeight.bold,
                                        color: AppC.white)),
                              ),
                              title: Text(
                                  "${model?['users']?['first_name'] ?? ''} ${model?['users']['last_name']}",style: context.textTheme.labelMedium?.copyWith(color: AppC.grey),),
                              subtitle: Text(GetTimeAgo.parse(DateTime.tryParse(model?['updated_at'] ?? "") ?? DateTime.now().toUtc())),
                              trailing:
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: 100),
                                child: Row(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () => context.read<FBEditBloc>().add(FBCommentsEditEvent(model)),
                                        child: Icon(Icons.edit_outlined, color:AppC.appColor,size: 18.sp,)
                                    ),
                                    GestureDetector(
                                        onTap: () => context.read<FBEditBloc>().add(FBCommentsEditEvent(model)),
                                        child: Icon(Icons.delete_outline, color:AppC.redAccent,size: 18.sp,)
                                    ),
                                  ],
                                ),
                              ),
                              titleTextStyle: context
                                  .textTheme.labelLarge
                                  ?.copyWith(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                              subtitleTextStyle: context
                                  .textTheme.labelSmall
                                  ?.copyWith(
                                  fontFamily: "Lato",
                                  fontWeight:
                                  FontWeight.normal),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50),
                                  child: Text(
                                    "${model?['comment']}",
                                    style:
                                    context.textTheme.labelMedium,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 3,

                                  ),
                                ),
                                if((model?['attachments'] != null) && (model?['attachments']is List) && (model?['attachments'] as List).isNotEmpty)...[
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(
                                          null,
                                          (model?['attachments'] as List).where(
                                                  (element) => element['path'].toString().isNotEmpty)
                                              .map((e) => e['path'].toString().toAttachmentURL).toList())),
                                      child:  Icon(Icons.image_outlined,size: 18.sp,color: AppC.appColor),
                                    ),
                                  ),
                                ] else...[
                                  const SizedBox.shrink(),
                                ]
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                ),
              ],
            ),
          )
        ],
        ),
      ) : const SizedBox.shrink()
    );
  }
}
