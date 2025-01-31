import 'package:fairpytasker/Component/badge_button.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackStatuses extends StatelessWidget {
  const FeedbackStatuses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackViewBloc, FeedBackViewState>(
      buildWhen: (previous, current) => (current is FeedBackViewShowStatusState) || (current is FeedBackOnStatusState),
      builder: (context, state) => (context.read<FeedBackViewBloc>().feedbackStatus?.isNotEmpty ?? false) ?  SizedBox(
        height: 60,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: context.read<FeedBackViewBloc>().feedbackStatus?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => BadgeButton(
            label: "${context.read<FeedBackViewBloc>().feedbackStatus?[index].name}",
            value: context.read<FeedBackViewBloc>().feedbackStatus?[index].id,
            selectedValue: context.read<FeedBackViewBloc>().selectedStatus,
            onPressed: (value) => context.read<FeedBackViewBloc>().add(FeedBackStatusEvent(value)),
            showBadge: true,
            count: context.read<FeedBackViewBloc>().findCount(context.read<FeedBackViewBloc>().feedbackStatus?[index].id),
          ),
          separatorBuilder: (BuildContext context, int index) => 10.width,
        ),
      ) : const SizedBox.shrink(),
    );
  }
}
