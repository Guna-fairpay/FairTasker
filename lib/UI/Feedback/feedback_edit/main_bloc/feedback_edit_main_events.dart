import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class FeedBackEditMainEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedBackTabChangeEvent extends FeedBackEditMainEvents {
  final int pageId;
  FeedBackTabChangeEvent(this.pageId);

  @override
  List<Object?> get props => [pageId, Random().nextDouble()];
}

class FeedBackEditMainSaveEvent extends FeedBackEditMainEvents {}
