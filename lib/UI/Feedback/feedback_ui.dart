import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_sub/feedback_view_body.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit_view_ui.dart';
import 'package:fairpytasker/Response/feedback_view_response.dart';
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
            if (state is FeedBackViewErrorState) {
              Utils.showMobileToast(state.message ?? "");
            } else if (state is FeedBackViewSuccessState) {
              Utils.showMobileToast(state.message ?? "");
            } else if (state is FeedBackViewAttachmentState) {
              ShowAttachmentsDialog.of.show(context, attachments: (state.attachments as List<Attachments>).map((e) => e.path.toAttachmentURL).toList() ?? [], title: state.title);
            } else if (state is FeedBackShowDeleteDialogState) {
              var result = await Utils.showCustomDeleteDialog(context, "Do you want to delete the feedback?");
              if (result) context.read<FeedBackViewBloc>().add(FeedBackDeleteConfirmEvent(state.feedBackId));
            } else if (state is FeedBackEditState) {
              // await context.push<FeedbackAddUI>(FeedbackEditViewUI(feedbacks: state.feedbacks, status: ""));
              if (context != null) await context.push<FeedbackAddUI>(FeedbackEditViewUI(feedBackId: state.feedBackId,), fullscreenDialog: true);
            } else if (state is FeedBackAddState) {
              if (context != null) await context.push<FeedbackAddUI>(const FeedbackAddUI());
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
