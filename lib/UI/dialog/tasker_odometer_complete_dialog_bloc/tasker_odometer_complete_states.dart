import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TOCDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TOCDLoadingState extends TOCDStates {}
class TOCDCommonState extends TOCDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TOCDErrorState extends TOCDStates {
  final String? message;
  TOCDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TOCDSuccessState extends TOCDStates {
  final String? message;
  TOCDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}