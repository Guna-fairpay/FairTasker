import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart' as d;
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FeedbackEditFeedAttachments extends StatelessWidget {
  const FeedbackEditFeedAttachments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
      buildWhen: (previous, current) => (current is FBFeedAttachmentState) || (current is FBFeedbackState),
      builder: (context, state) => GridView.builder(
              shrinkWrap: true,
              itemCount: (context.read<FBEditBloc>().feedAttachments).length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                var models = (context.read<FBEditBloc>().feedAttachments);
                var model = models[index];
                return ((index == 0) || (model == null))
                    ? CloseBadge(
                  showClose: false,
                  onTapView: () => context.read<FBEditBloc>().add(FBFeedAddAttachmentEvent()),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height,
                      minWidth: MediaQuery.sizeOf(context).width,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppC.grey.withValues(alpha: 0.2)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.black54,
                    ),
                  ),
                )
                    : CloseBadge(
                  showClose: (model is! String),
                  onTapView: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(model, models)),
                  onTapDelete: () => context.read<FBEditBloc>().add(FBFeedRemoveAttachmentEvent(model)),
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
                  ),
                );
              },
            ),
    );
  }
}
