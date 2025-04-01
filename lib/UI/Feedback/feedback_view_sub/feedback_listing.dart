import 'package:fairpytasker/Component/feedback_tile.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackListing extends StatelessWidget {
  const FeedbackListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackViewBloc, FeedBackViewState>(
      buildWhen: (previous, current) => current is FeedBackViewShowState,
      builder: (context, state) => (context.read<FeedBackViewBloc>().filteredFeedback?.isNotEmpty ?? false)
          ? Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) => FeedBackTile(
                        isOdd: (index % 2 == 0),
                        feedback: context.read<FeedBackViewBloc>().filteredFeedback?[index],
                        onPressed: () => context.read<FeedBackViewBloc>().add(FeedBackEditEvent(context.read<FeedBackViewBloc>().filteredFeedback?[index].id, context.read<FeedBackViewBloc>().filteredFeedback?[index].toJson() ?? {})),
                        onDelete: () => context
                            .read<FeedBackViewBloc>()
                            .add(FeedBackDeleteEvent(context.read<FeedBackViewBloc>().filteredFeedback?[index].id?.toInt())),
                        onViewAttachment: () => context
                            .read<FeedBackViewBloc>()
                            .add(FeedBackViewAttachmentEvent(
                            context.read<FeedBackViewBloc>().filteredFeedback?[index].attachments, context.read<FeedBackViewBloc>().filteredFeedback?[index].title)),
                      ),
                  separatorBuilder: (context, index) => 10.height,
                  itemCount: (context.read<FeedBackViewBloc>().filteredFeedback?.length ?? 0)),
            )
          : Container(),
    );
  }
}
