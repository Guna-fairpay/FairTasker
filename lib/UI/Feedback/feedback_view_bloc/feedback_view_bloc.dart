import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_view_bloc/feedback_view_states.dart';
import 'package:fairpytasker/Response/feedback_status_response.dart';
import 'package:fairpytasker/Response/feedback_view_response.dart';
import 'package:fairpytasker/Repository/feedback_repository.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class FeedBackViewBloc extends Bloc<FeedBackViewEvent, FeedBackViewState> {
  final FeedBackRepository feedBackRepository = FeedBackRepository();
  final TextEditingController searchController = TextEditingController();
  List<Feedback>? feedback = [], filteredFeedback = [];
  List<StatusList>? feedbackStatus = [];
  dynamic selectedStatus;
  bool isRefreshing = false;
  FeedBackViewBloc() : super(FeedBackViewLoadingState()) {
    on<FeedBackInitialEvent>((event, emit) async {
      emit(FeedBackViewLoadingState());
      try {
        var mainResponse = await Future.wait([
          _fetchApi(),
          _fetchStatusApi()
        ]);
        var feedBacks = mainResponse.first;
        var statuses = mainResponse.last;
        var response = (feedBacks is FeedbackViewResponse) ? feedBacks : null;
        var statusResponse = (statuses is FeedbackStatusResponse) ? statuses : null;
        emit(FeedBackViewLoadedState());
        if (statusResponse != null && (statusResponse.statusList?.isNotEmpty ?? false)) {
          selectedStatus = statusResponse.statusList?[0].id;
          emit(FeedBackViewShowStatusState(feedbackStatus = statusResponse.statusList));
        }
        if (response != null && (response.feedback?.isNotEmpty ?? false)) {
          var feeds = response.feedback?.sortedByCompare((element) => element.id, (a, b) => (b?.compareTo(a ?? 0) ?? 0));
          feedback = feeds;
          filteredFeedback = feeds?.where((element) => element.status == selectedStatus).toList();
          emit(FeedBackViewShowState(filteredFeedback));
        }
      } catch (e) {
        emit(FeedBackViewErrorState(e.toString()));
      }
    });

    on<FeedBackViewAttachmentEvent>((event, emit) => emit(FeedBackViewAttachmentState(event.attachments, event.title)));
    on<FeedBackDeleteEvent>((event, emit) => emit(FeedBackShowDeleteDialogState(event.feedBackId)));

    on<FeedBackDeleteConfirmEvent>((event, emit) async {
      try {
        var response = await feedBackRepository.deleteFeedback(
            event.feedBackId);
        if (response != null) {
          emit(FeedBackViewSuccessState(response['message']));
          feedback?.removeWhere((element) => element.id == event.feedBackId);
          filteredFeedback =
              feedback?.where((element) => element.status == selectedStatus)
                  .toList();
          emit(FeedBackViewShowState(filteredFeedback));
          emit(FeedBackOnStatusState());
        }
      } catch (e) {
        emit(FeedBackViewErrorState(e.toString()));
      }
    });

    on<FeedBackStatusEvent>((event, emit) {
      selectedStatus = event.status;
      filteredFeedback = feedback?.where((element) => element.status == selectedStatus).toList();
      emit(FeedBackViewShowState(filteredFeedback));
      emit(FeedBackOnStatusState());
    });

    on<FeedBackSearchEvent>((event, emit) {
      if (event.searchQuery?.isEmpty ?? true) {
        filteredFeedback = feedback?.where((element) => element.status == selectedStatus).toList();
        emit(FeedBackViewShowState(filteredFeedback));
      }
      filteredFeedback = feedback?.where((element) => element.status == selectedStatus).where((element) => element.title?.toLowerCase().contains(event.searchQuery?.toLowerCase() ?? "") ?? false).toList();
      emit(FeedBackViewShowState(filteredFeedback));
    });

    on<FeedBackAddNewEvent>((event, emit) => emit(FeedBackAddState()));
    on<FeedBackEditEvent>((event, emit) => emit(FeedBackEditState(event.feedBackId, event.feedbacks)));
  }

  Future<FeedbackViewResponse?> _fetchApi() async {
    return await feedBackRepository.fetchFeedback();
  }

  Future<FeedbackStatusResponse?> _fetchStatusApi() async {
    return await feedBackRepository.fetchFeedbackStatus();
  }

  int findCount(dynamic status) {
    if (feedback?.isEmpty ?? false) return 0;
    return feedback?.where((element) => element.status == status).length ?? 0;
  }

}