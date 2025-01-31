import 'package:equatable/equatable.dart';

class FeedBackEditMainState extends Equatable {

  final int pageId;

  const FeedBackEditMainState({required this.pageId});

  FeedBackEditMainState copyWith({int? pageId}) {
    return FeedBackEditMainState(pageId: pageId ?? this.pageId);
  }

  @override
  List<Object?> get props => [pageId];

}