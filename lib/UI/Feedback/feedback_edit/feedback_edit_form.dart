import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/feedback_edit_feed_attachments.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackEditForm extends StatelessWidget {
  const FeedbackEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
      buildWhen: (previous, current) => current is FBFeedbackState || current is FBCommentState,
        builder: (context, state) => ((context.read<FBEditBloc>().pageId == 0) && (state is FBFeedbackState)) ? Expanded(
                child: Form(
                    child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Utils.getTextFormField(
                  'Title',
                  hintText: "Enter your title...",
                  inputAction: TextInputAction.done,
                  autoValidate: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      (value?.isEmpty ?? false) ? "Title is required" : null,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  state.titleController,
                ),
                10.height,
                DropdownButtonFormField<String>(
                  items: ["Select Priority", "High", "Medium", "Low"]
                      .map((e) =>
                          DropdownMenuItem<String>(value: e.toLowerCase(), child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                  value: state.priority,
                  validator: (value) =>
                      (value == null) ? "Priority is required" : null,
                  borderRadius: BorderRadius.circular(5),
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      hintText: "Select your Priority",
                      filled: true,
                      hintStyle: context.textTheme.labelMedium?.copyWith(
                          color: context.theme.hintColor,
                          fontWeight: FontWeight.bold),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none)),
                ),
                10.height,
                CustomQuillEditor(
                  controller: state.descriptionController,
                  hintText: "Enter your description here...",
                ),
                10.height,
                const Text("Attachments"), // ATTACHMENTS
                5.height,
                const FeedbackEditFeedAttachments(),
                16.height,
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppC.green.withValues(alpha: 0.7),
                      ),
                      foregroundColor: const WidgetStatePropertyAll(
                        AppC.white,
                      ),
                      textStyle: WidgetStatePropertyAll(context
                          .textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  child: const Text("Submit"),
                ),
              ],
            ))) : SizedBox.shrink());
  }
}
