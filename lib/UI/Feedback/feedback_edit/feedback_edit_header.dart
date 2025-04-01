import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FeedBackEditHeader extends StatelessWidget {
  const FeedBackEditHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
        builder: (context, state) => Container(
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                  border: BorderDirectional(bottom: BorderSide(width: 0.2))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 2,
                children: [
                  FeedbackTabButton(
                      buttonText: "Feedback",
                      value: 0,
                      selectedValue: context.read<FBEditBloc>().pageId,
                      onPressed: (val) => context
                          .read<FBEditBloc>()
                          .add(FBPageEvent(val))),
                  FeedbackTabButton(
                      buttonText: "Comments",
                      value: 1,
                      selectedValue: context.read<FBEditBloc>().pageId,
                      badgeCount: context
                              .read<FBEditBloc>()
                              .commentResponse['comments']
                              ?.length ??
                          0,
                      showBade: true,
                      onPressed: (val) => context
                          .read<FBEditBloc>()
                          .add(FBPageEvent(val))),
                  const Spacer()
                ],
              ),
            ));
  }
}
