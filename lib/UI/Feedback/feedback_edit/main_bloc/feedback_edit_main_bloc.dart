import 'package:fairpytasker/UI/Feedback/feedback_edit/main_bloc/feedback_edit_main_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/main_bloc/feedback_main_state.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackEditMainBloc extends Bloc<FeedBackEditMainEvents, FeedBackEditMainState> {
  final FBroadcast broadcast = FBroadcast.instance();
  FeedBackEditMainBloc(): super(const FeedBackEditMainState(pageId: 0)) {
    on<FeedBackTabChangeEvent>((event, emit)=> emit(state.copyWith(pageId: event.pageId)));
    on<FeedBackEditMainSaveEvent>((event, emit) => broadcast.broadcast("save_edit", value: true));
  }

}