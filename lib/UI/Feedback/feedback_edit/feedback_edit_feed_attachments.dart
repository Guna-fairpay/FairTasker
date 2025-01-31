import 'dart:io';

import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart' as d;
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                var model = (context.read<FBEditBloc>().feedAttachments)[index];
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
                    child: ((model as Object).isImage) ? ImageViewer(
                        fit: BoxFit.cover,
                        imageInput: model) :
                    (!((model).isImage))
                    ? VideoPlayerView(videoInput: model, fillHeight: true, showMediaControllers: false, enableAudio: false)
                    : Container(),
                  ),
                );
              },
            ),
    );
  }
}
