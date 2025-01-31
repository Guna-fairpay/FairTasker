import 'package:fairpytasker/UI/Feedback/feedback_view_sub/feedback_listing.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_sub/feedback_searchbar.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_sub/feedback_statuses.dart';
import 'package:flutter/material.dart';

class FeedBackViewBody extends StatelessWidget {
  const FeedBackViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeedbackSearchbar(),
        const FeedbackStatuses(),
        const FeedbackListing(),
      ],
    );
  }
}
