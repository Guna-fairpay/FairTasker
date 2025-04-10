import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class CompactPagination extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  const CompactPagination({super.key, required this.totalPages, required this.currentPage, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return NumberPagination(
      onPageChanged: onPageChanged,
      totalPages: totalPages,
      currentPage: currentPage,
      enableInteraction: true,
      betweenNumberButtonSpacing: 0,
      buttonRadius: 3,
      sectionSpacing: 0,
      visiblePagesCount: 5,
      controlButtonSize: const Size.fromRadius(20),
      numberButtonSize: const Size.fromRadius(20),
      fontFamily: "Lato",
      buttonElevation: 0,
      navigationButtonSpacing: 0,
      controlButtonColor: AppC.lightGrey,
      unSelectedButtonColor: AppC.trans,
      selectedButtonColor: AppC.appColor,
      selectedNumberFontWeight: FontWeight.bold,
      unSelectedNumberColor: AppC.text,
    );
  }
}
