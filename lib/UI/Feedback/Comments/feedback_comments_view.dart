import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '../../../Component/close_badge.dart';
import '../../../Component/image_viewer.dart';
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
                Utils.getTextFormField("Add your comment", context.read<FBEditBloc>().commentController),
                10.height,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GestureDetector(
                          onTap: ()=> context.read<FBEditBloc>().add(FBCommentAddAttachmentEvent()),
                          child:
                          Row(
                            children: [
                              Material(
                                color: const Color(0xFFeaf0fa),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                                child:
                                InkWell(
                                  onTap: () => context.read<FBEditBloc>().add(FBCommentAddAttachmentEvent()),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Choose File",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text("No file chosen"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                10.height,
                // if (context.read<FBEditBloc>().isEdit &&
                //     state.comments.any((comment) =>
                //     comment['id'] ==
                //         context.read<FBEditBloc>().commentId)) ...[
                //   SizedBox(
                //     height: 100,
                //     child: GridView.builder(
                //       gridDelegate:
                //       const SliverGridDelegateWithFixedCrossAxisCount(
                //           mainAxisSpacing: 10,
                //           crossAxisCount: 1),
                //       shrinkWrap: true,
                //       scrollDirection: Axis.horizontal,
                //       clipBehavior: Clip.antiAliasWithSaveLayer,
                //       itemBuilder: (context, index) {
                //         var model = context.read<FBEditBloc>().commentAttachments[index];
                //         var metadata = context.read<FBEditBloc>().attachmentMetadata[index];
                //         String attachmentId = metadata['id'].toString();
                //         return CloseBadge(
                //             onTapDelete: () => context.read<FBEditBloc>().add(FBCommentRemoveAttachmentEvent(attachmentId)),
                //             onTapView: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(model, context.read<FBEditBloc>().commentAttachments)),
                //             child: Container(
                //               constraints: BoxConstraints(
                //                 minHeight: MediaQuery.sizeOf(context).height,
                //                 minWidth: MediaQuery.sizeOf(context).width,
                //               ),
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(16),
                //                   color: AppC.grey.withValues(alpha: 0.2)),
                //               clipBehavior: Clip.antiAliasWithSaveLayer,
                //               child: ImageViewer(
                //                 fit: BoxFit.cover,
                //                 imageInput: model,
                //                 isNotImage: !((model as Object).isImage),
                //               ),
                //             ));
                //       },
                //       itemCount: context.read<FBEditBloc>().commentAttachments.length,
                //     ),
                //   ),
                // ],
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
                Utils.getText("Comments"),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var model = state.comments[index];
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
                        child: GestureDetector(
                          onTap: () => context.read<FBEditBloc>().add(FBCommentsEditEvent(model)),
                          child: Card.outlined(
                            elevation: 3,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    minVerticalPadding: 0,
                                    leading: CircleAvatar(
                                      child: Center(
                                          child: Utils.getText(<String>[(model?['users']?['first_name'] ?? ''), (model?['users']?['last_name'] ?? '')].toInitial,
                                              size: 16,
                                              weight: FontWeight.bold,
                                              color: AppC.white)),
                                    ),
                                    title: Text(
                                        "${model?['users']?['first_name'] ?? ''} ${model?['users']['last_name']}"),
                                    subtitle: Text(GetTimeAgo.parse(DateTime.tryParse(model?['created_at'] ?? "") ?? DateTime.now().toUtc())),
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
                                              child: Icon(Icons.edit_outlined, color:AppC.appColor)
                                          ),
                                          if((model?['attachments'] != null) && (model?['attachments']is List) && (model?['attachments'] as List).isNotEmpty)...[
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(
                                                    null,
                                                    (model?['attachments'] as List).where(
                                                            (element) => element['path'].toString().isNotEmpty)
                                                        .map((e) => e['path'].toString().toAttachmentURL).toList())),
                                                child: const Icon(Icons.attach_file_rounded),
                                              ),
                                            ),
                                          ] else...[
                                            const SizedBox.shrink(),
                                          ]
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "${model?['comment']}",
                                      style:
                                      context.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 5.height,
                    itemCount: state.comments.length
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
