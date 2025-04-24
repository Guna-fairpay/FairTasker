import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_sub/feedback_view_body.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit_view_ui.dart';
import 'package:fairpytasker/Response/feedback_view_response.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'feedback_add_ui.dart';

class FeedBackUI extends StatelessWidget {
  const FeedBackUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBackViewBloc()..add(FeedBackInitialEvent()),
      child: BlocListener<FeedBackViewBloc, FeedBackViewState>(
        listenWhen: (previous, current) =>
            (current is FeedBackViewLoadingState) ||
            (current is FeedBackViewLoadedState) ||
            (current is FeedBackViewErrorState) ||
            (current is FeedBackViewSuccessState) ||
            (current is FeedBackViewAttachmentState) ||
            (current is FeedBackShowDeleteDialogState) ||
                (current is FeedBackEditState) ||
                (current is FeedBackAddState),
        listener: (context, state) async {
          if (state is FeedBackViewLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case FeedBackViewErrorState(): Toaster.showError(state.message); break;
              case FeedBackViewSuccessState(): Toaster.showSuccess(state.message); break;
              case FeedBackViewAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: (state.attachments as List<Attachments>).map((e) => e.path.toAttachmentURL).toList() ?? [], title: state.title); break;
              case FeedBackShowDeleteDialogState(): AskPermissionDialog.show(context, description: "Do you want to delete the feedback?", onPositivePressed: () => context.read<FeedBackViewBloc>().add(FeedBackDeleteConfirmEvent(state.feedBackId))); break;
              case FeedBackEditState(): context.push<FeedbackEditViewUI>(FeedbackEditViewUI(feedBackId: state.feedBackId,), fullscreenDialog: true); break; // FeedBackEditViewUI
              case FeedBackAddState(): context.push<FeedbackAddUI>(const FeedbackAddUI(), fullscreenDialog: true); break;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const FeedBackViewBody(),
        ),
      ),
    );
  }
}
