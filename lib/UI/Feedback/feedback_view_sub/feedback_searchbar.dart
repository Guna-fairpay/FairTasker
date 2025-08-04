import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackSearchbar extends StatelessWidget {
  const FeedbackSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackViewBloc, FeedBackViewState>(
      buildWhen: (previous, current) => current is FeedBackViewLoadedState,
      builder: (context, state) => ListTile(
        title: CompactSearchView(
          controller: context.read<FeedBackViewBloc>().searchController,
          hintText: "Search...",
          onChanged: (value) => context.read<FeedBackViewBloc>().add(FeedBackSearchEvent(value)),
        ),
        dense: true,
        contentPadding: const EdgeInsets.all(10),
        trailing: SuccessButton(
          backgroundColor: AppC.appColor,
          icon: Icons.add_rounded,
          text: "Add",
          onPressed: () => context.read<FeedBackViewBloc>().add(FeedBackAddNewEvent()),
        ),
      ),
    );
  }
}
