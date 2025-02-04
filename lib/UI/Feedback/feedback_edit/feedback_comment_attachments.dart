import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackCommentAttachments extends StatelessWidget {
  const FeedbackCommentAttachments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
      buildWhen: (previous, current) => current is FBCommentAttachments,
      builder: (context, state) => ((state is FBCommentAttachments) && (context.read<FBEditBloc>().commentAttachments.isNotEmpty)) ? Container(
        constraints: const BoxConstraints(maxHeight: 80),
        child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisCount: 1),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          itemBuilder: (context, index) {
            var model = context.read<FBEditBloc>().commentAttachments[index];
            return CloseBadge(
                onTapDelete: () => context.read<FBEditBloc>().add(FBCommentRemoveAttachmentEvent(model)),
                onTapView: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(model, context.read<FBEditBloc>().commentAttachments)),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height,
                    minWidth: MediaQuery.sizeOf(context).width,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppC.grey.withValues(alpha: 0.2)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ImageViewer(
                    fit: BoxFit.cover,
                    imageInput: model,
                    isNotImage: !((model as Object).isImage),
                  ),
                ));
          },
          itemCount: context.read<FBEditBloc>().commentAttachments.length,
        ),
      ) : const SizedBox.shrink(),
    );
  }
}
