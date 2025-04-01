import 'dart:async';

import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackSearchbar extends StatelessWidget {
  Timer? _timer;

  FeedbackSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackViewBloc, FeedBackViewState>(
      buildWhen: (previous, current) => current is FeedBackViewLoadedState,
      builder: (context, state) => ListTile(
        title: SearchBar(
          controller: context.read<FeedBackViewBloc>().searchController,
          onChanged: (value) {
            _timer?.cancel();
            _timer = Timer(
                Durations.medium3,
                () => context
                    .read<FeedBackViewBloc>()
                    .add(FeedBackSearchEvent(value)));
          },
          onSubmitted: (value) =>
              context.read<FeedBackViewBloc>().add(FeedBackSearchEvent(value)),
          hintText: "Search...",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          padding: WidgetStatePropertyAll(5.padding.copyWith(left: 10)),
          constraints: const BoxConstraints(),
          leading: const Icon(Icons.search_rounded, color: Colors.grey),
          shape: WidgetStatePropertyAll(ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge))),
        ),
        dense: true,
        contentPadding: const EdgeInsets.all(10),
        trailing: ElevatedButton.icon(
          onPressed: () => context.read<FeedBackViewBloc>().add(FeedBackAddNewEvent()),
          label:
              Utils.getText("Add", color: AppC.white, weight: FontWeight.bold),
          icon: const Icon(Icons.add_rounded),
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppC.appColor),
              iconColor: const WidgetStatePropertyAll(AppC.white),
              textStyle: WidgetStatePropertyAll(Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppC.white)),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16)))),
        ),
      ),
    );
  }
}
