import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TMPDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TMPDLoadingState extends TMPDStates {}
class TMPDCommonState extends TMPDStates{
  @override
  List<Object?> get props => [Random().nextDouble()];
}